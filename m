Return-Path: <linux-kernel-owner+w=401wt.eu-S1763079AbXFBTwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763079AbXFBTwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 15:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761018AbXFBTwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 15:52:15 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:62037 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbXFBTwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 15:52:14 -0400
Date: Sat, 2 Jun 2007 21:53:57 +0200
From: DervishD <lkml@dervishd.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel utf-8 handling
Message-ID: <20070602195357.GA430@DervishD>
Mail-Followup-To: Jan Engelhardt <jengelh@linux01.gwdg.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070601142058.GA2587@DervishD> <Pine.LNX.4.61.0706012117250.11140@yvahk01.tjqt.qr> <46609C8B.4000606@zytor.com> <20070602075845.GC20406@DervishD> <Pine.LNX.4.61.0706021246350.21057@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0706021246350.21057@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Jan :)

 * Jan Engelhardt <jengelh@linux01.gwdg.de> dixit:
> On Jun 2 2007 09:58, DervishD wrote:
> >
> > * H. Peter Anvin <hpa@zytor.com> dixit:
> >> Jan Engelhardt wrote:
> >> > (1) I can do <Compose><~><n> just fine on vt
> >> > (2) I can do <ö> just fine on vt too
> >> > (3) And copy+paste them both using GPM too, again w/o probs
> >> 
> >> Both of those are in the 0-255 range, though.  I thought the issue was
> >> with characters 256+, like ??.  At least on my FC6 system that doesn't
> >> work with gpm.
> 
> I've got a cp437 "DOS" font loaded[1], and giving a glance at
> /usr/share/kbd/unimaps/cp437.uni tells me right away:
> 
> 	0x01 U+263A
> 
> So I create U+263A in joe (ESC ' x 2 6 3 a), it displays fine (the
> smiley character), and I can copy/paste it using GPM without
> problems. Though, I have that patch[2] in my kernel. Can you check
> if it works if you apply it?

    I cannot reboot my machine right now, and I don't have GPM
installed, but if you give me a few days I think I'll be able to test.
I have to upgrade the kernel too (I'm using 2.6.19.5), so make it a week
O:)) I'll test ASAP.

    And thanks for the patch :))

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
