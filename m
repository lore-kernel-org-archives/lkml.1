Return-Path: <linux-kernel-owner+w=401wt.eu-S1759647AbXFBKxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647AbXFBKxZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 06:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758371AbXFBKxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 06:53:15 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:54278 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385AbXFBKxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 06:53:14 -0400
Date: Sat, 2 Jun 2007 12:51:29 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: DervishD <lkml@dervishd.net>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel utf-8 handling
In-Reply-To: <20070602075845.GC20406@DervishD>
Message-ID: <Pine.LNX.4.61.0706021246350.21057@yvahk01.tjqt.qr>
References: <20070601142058.GA2587@DervishD> <Pine.LNX.4.61.0706012117250.11140@yvahk01.tjqt.qr>
 <46609C8B.4000606@zytor.com> <20070602075845.GC20406@DervishD>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 2 2007 09:58, DervishD wrote:
>
> * H. Peter Anvin <hpa@zytor.com> dixit:
>> Jan Engelhardt wrote:
>> > (1) I can do <Compose><~><n> just fine on vt
>> > (2) I can do <ö> just fine on vt too
>> > (3) And copy+paste them both using GPM too, again w/o probs
>> 
>> Both of those are in the 0-255 range, though.  I thought the issue was
>> with characters 256+, like ??.  At least on my FC6 system that doesn't
>> work with gpm.

I've got a cp437 "DOS" font loaded[1], and giving a glance at
/usr/share/kbd/unimaps/cp437.uni tells me right away:

	0x01 U+263A

So I create U+263A in joe (ESC ' x 2 6 3 a), it displays fine (the
smiley character), and I can copy/paste it using GPM without
problems. Though, I have that patch[2] in my kernel. Can you check
if it works if you apply it?


[1] https://dev.computergmbh.de/svn/hxtools/trunk/kbd/ahnv.fnt
[2] http://lkml.org/lkml/2007/6/1/339
    (I also have it for 2.6.18 and 2.6.20 if you need)



	Jan
-- 
