Return-Path: <linux-kernel-owner+w=401wt.eu-S1161142AbXCGH1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161142AbXCGH1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161020AbXCGH1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:27:22 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:2797 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161142AbXCGH1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:27:21 -0500
Message-ID: <45EE6A00.2080507@sw.ru>
Date: Wed, 07 Mar 2007 10:30:08 +0300
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@osdl.org>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, devel@openvz.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       containers@lists.osdl.org, Kirill Korotaev <dev@sw.ru>
Subject: Re: [RFC][PATCH 0/7] Resource controllers based on process containers
References: <45ED7DEC.7010403@sw.ru> <6599ad830703061802g37629faayf7cb2a94bd74ce25@mail.gmail.com>
In-Reply-To: <6599ad830703061802g37629faayf7cb2a94bd74ce25@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On 3/6/07, Pavel Emelianov <xemul@sw.ru> wrote:
>> 2. Extended containers may register themselves too late.
>>    Kernel threads/helpers start forking, opening files
>>    and touching pages much earlier. This patchset
>>    workarounds this in not-so-cute manner and I'm waiting
>>    for Paul's comments on this issue.
>>
> 
> Can we not make sure that each subsystem registers itself before any
> of its resources become usable? So the file counting subsystem should

Actually all the subsystems I've sent became usable very early.
Much earlier that initcalls started. I didn't found where exactly
but I can make it if we really need it.

> register at some point before filp_open() becomes usable, and the
> process counting subsystem should register before it's possible to
> fork, etc.
> 
> Paul
> 

