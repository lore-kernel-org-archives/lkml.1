Return-Path: <linux-kernel-owner+w=401wt.eu-S1763489AbZFPVXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763489AbZFPVXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 17:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756430AbZFPVXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 17:23:05 -0400
Received: from imp03.mtu.ru ([62.5.255.20]:32902 "EHLO imp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbZFPVXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 17:23:04 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jun 2009 17:23:03 EDT
Message-ID: <4A380C49.6050206@aknet.ru>
Date: Wed, 17 Jun 2009 01:19:05 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Tejun Heo <tj@kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Chuck Ebbert <76306.1226@compuserve.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ping: Re: [PATCH 0/2] i386: espfix fixes
References: <1244378557-5455-1-git-send-email-heukelum@fastmail.fm> <1245182594.27756.1320705931@webmail.messagingengine.com>
In-Reply-To: <1245182594.27756.1320705931@webmail.messagingengine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

17.06.2009 00:03, Alexander van Heukelum wrote:
> Just wanted to get a little attention for the espfix fixes...
>
> http://lkml.org/lkml/2009/6/7/106 : fix return to 16-bit stack from NMI
> http://lkml.org/lkml/2009/6/7/109 : fix/simplify espfix, move it into
> assembly
>
> Any objections against those?
Well, the dynamic limits were advocated
by Zach and Chuck, so lets ask them first
(added CCs).

For the rest:
Acked-by: Stas Sergeev <stsp@aknet.ru>

In particular, I am asking now myself why
have I used THREAD_SIZE there, and can't
recall the reason...
