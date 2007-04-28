Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbXD1LFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbXD1LFQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 07:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbXD1LFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 07:05:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49337 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbXD1LFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 07:05:13 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Back to the future.
To: Pavel Machek <pavel@ucw.cz>, David Lang <david.lang@digitalinsight.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Sat, 28 Apr 2007 13:04:45 +0200
References: <8e5l8-7SD-21@gated-at.bofh.it> <8e6Ka-1uR-3@gated-at.bofh.it> <8e6TS-1Id-11@gated-at.bofh.it> <8efu9-6mF-1@gated-at.bofh.it> <8ekWV-6FF-33@gated-at.bofh.it> <8el6y-6Sj-5@gated-at.bofh.it> <8elpT-7wY-21@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1HhkjN-0000nb-6D@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX183vXBxaFwsPryrpWJpVqhxA4PpjtKAyjlyQSn
 fSFvNouS/N+Ezc4RJic67/vAAJJGzYQP8D0vWP0IQFX0Xvs+VW
 IqAp1rfEWNNVCsamgcQZQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> wrote:

>> I also don't like the idea of storing this in the swap partition for a
>> couple of reasons.
>> 
>> 1. on many modern linux systems the swap partition is not large enough.
>> 
>> for example, on my boxes with 16G or ram I only allocate 2G of swap
>> space
> 
> WTF? So allocate larger swap partition. You just told me disks are big
> enough.

1) Repartitioning is sometimes not an option.
2) What happens, if the swap space gets used?

I want to be sure I can suspend my {server,laptop} in case of power running
out. Using swap is only an option for desktops.

>> 2. it's too easy for other things to stomp on your swap partition.
>> 
>>   for example: booting from a live CD that finds and uses swap
>> partitions
> 
> That's a feature. If you are booting from live CD, you _want_ to erase
> any hibernation image.

NACK. You want to keep all partitions related to the hibernated system
read-only. That's completely different from destroying all your unsafed
data and possibly long-running tasks.
-- 
Top 100 things you don't want the sysadmin to say:
51. YEEEHA!!!  What a CRASH!!!

Friﬂ, Spammer: C@rzlmn.7eggert.dyndns.org D9GLNDg@Zk.7eggert.dyndns.org
