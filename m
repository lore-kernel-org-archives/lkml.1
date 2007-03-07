Return-Path: <linux-kernel-owner+w=401wt.eu-S1161294AbXCGHan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161294AbXCGHan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 02:30:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161297AbXCGH3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 02:29:47 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:15597 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161294AbXCGH3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 02:29:21 -0500
Message-ID: <45EE6A77.7070002@sw.ru>
Date: Wed, 07 Mar 2007 10:32:07 +0300
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: balbir@in.ibm.com
CC: Andrew Morton <akpm@osdl.org>, Paul Menage <menage@google.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, devel@openvz.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       containers@lists.osdl.org, Kirill Korotaev <dev@sw.ru>
Subject: Re: [RFC][PATCH 0/7] Resource controllers based on process containers
References: <45ED7DEC.7010403@sw.ru> <45EE6112.7050702@in.ibm.com>
In-Reply-To: <45EE6112.7050702@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Pavel Emelianov wrote:
>> This patchset adds RSS, accounting and control and
>> limiting the number of tasks and files within container.
>>
>> Based on top of Paul Menage's container subsystem v7
>>
>> RSS controller includes per-container RSS accounter,
>> reclamation and OOM killer. It behaves like standalone
>> machine - when container runs out of resources it tries
>> to reclaim some pages and if it doesn't succeed in it
>> kills some task which mm_struct belongs to container in
>> question.
>>
>> Num tasks and files containers are very simple and
>> self-descriptive from code.
>>
>> As discussed before when a task moves from one container
>> to another no resources follow it - they keep holding the
>> container they were allocated in.
>>
> 
> I have one problem with the patchset, I cannot compile
> the patches individually and some of the code is hard
> to read as it depends on functions from future patches.
> Patch 2, 3 and 4 fail to compile without patch 5 applied.
> 
> Patch 1 failed to apply with a reject in kernel/Makefile
> I applied it on top of 2.6.20 with all of Paul Menage's
> patches (all 7).

This sounds weird for me :( I've taken a stock 2.6.20
and applied Paul's patches. This is what this patchset
is applicable for.
