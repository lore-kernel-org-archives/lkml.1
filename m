Return-Path: <linux-kernel-owner+w=401wt.eu-S1763605AbXFATWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763605AbXFATWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762107AbXFATWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:22:08 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:50842 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762182AbXFATWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:22:06 -0400
Date: Fri, 1 Jun 2007 21:21:49 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: DervishD <lkml@dervishd.net>
cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Kernel utf-8 handling
In-Reply-To: <20070601142058.GA2587@DervishD>
Message-ID: <Pine.LNX.4.61.0706012117250.11140@yvahk01.tjqt.qr>
References: <20070601142058.GA2587@DervishD>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 1 2007 16:20, DervishD wrote:
>
>    This said, I know that the console will give me no problems
>regarding character representantion (heck, I'm pretty sure that I will
>be able to use even the same font I'm using right now in the console if
>I get the proper unicode map), but probably will give me problems when
>*entering* characters. I've read that the kernel handles accented chars,
>and things like 'ñ' (ntilde) because it assumes that any composed
>character (composed using dead keys, for example) is in the latin1
>range. While this is not a perfect behaviour, it will work for me.

(1) I can do <Compose><~><n> just fine on vt
(2) I can do <ö> just fine on vt too
(3) And copy+paste them both using GPM too, again w/o probs

so not sure where your problem is. I do however have a patch that
you could try should a problem arise. I should repost and ask
around again and beat until it's in :)



	Jan
-- 
