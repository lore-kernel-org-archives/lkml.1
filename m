Return-Path: <linux-kernel-owner+w=401wt.eu-S1758623AbXGBNMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623AbXGBNMD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 09:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754416AbXGBNLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 09:11:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54581 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbXGBNLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 09:11:52 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: blink driver power saving
To: Andi Kleen <ak@suse.de>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Reply-To: 7eggert@gmx.de
Date: Mon, 02 Jul 2007 15:11:44 +0200
References: <8CaWr-2o4-19@gated-at.bofh.it> <8Cfjl-PJ-33@gated-at.bofh.it> <8CfW1-1TX-23@gated-at.bofh.it> <8ChEo-4yy-1@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1I5Lgu-0000mK-7V@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/GGYi14MCisaERCTF032c//iA7vFoQmS1O5wM
 6UVYifv+xwHl/QVfw/IHfhbNX/+G6qBS9hesjeEVk+MzFcHiPV
 qd32nSoL3fdMysSCeWpVw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> wrote:
> On Monday 02 July 2007 00:14, Linus Torvalds wrote:
>> On Sun, 1 Jul 2007, Andi Kleen wrote:

>> > What is so bad with it? Note it's a debugging facility and used
>> > for kcrash kernels where the video output doesn't work. But they
>> > normally only run a few minutes to dump the previous state to disk
>> > and then reboot.
>>
>> It has been a total disaster from beginning to end.
>>
>> It wastes power.
> 
> Again:
> It's not intended for normal kernels. It's a debugging feature.
> It's not intended for normal kernels. It's a debugging feature.
> It's not intended for normal kernels. It's a debugging feature.
> 
> Got it now? Power wasting or not just doesn't matter for it.

There may be some setups that would overheat due to the sudden load,
while still running fine under normal conditions. Especially if the
fan is off or broken.
-- 
Fun things to slip into your budget
An abacus

Friﬂ, Spammer: FK2F@ugyhXY.7eggert.dyndns.org u@zq7ggfIq.7eggert.dyndns.org
