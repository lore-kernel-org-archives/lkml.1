Return-Path: <linux-kernel-owner+w=401wt.eu-S1751674AbXD1HtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbXD1HtF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 03:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbXD1HtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 03:49:05 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:58613 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbXD1HtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 03:49:04 -0400
Date: Sat, 28 Apr 2007 09:47:16 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: linux1394-devel@lists.sourceforge.net, Ben Collins <bcollins@debian.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/30] Use menuconfig objects - IEEE1394
In-Reply-To: <4632638D.2050004@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.61.0704280944100.506@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704102316160.32056@yvahk01.tjqt.qr> <4632638D.2050004@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 27 2007 22:56, Stefan Richter wrote:

>> -config IEEE1394
>> +menuconfig IEEE1394
>>  	tristate "IEEE 1394 (FireWire) support"
>>  	depends on PCI || BROKEN
>>  	select NET
>[...]
>
>Unless there are objections, I will merge it into my queue of IEEE 1394
>updates for Linus.

Yes, I do have objections now that the ieee1394 is different in
2.6.21-rc7-mm1.
Now you have two options in the firewire menu, namely the new
stack and the old stack. Then menuconfig is not really suitable
anymore.
So please skip it until the old stack finds its way out (which may
take some more time, yes).


Jan
-- 
