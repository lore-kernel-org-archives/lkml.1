Return-Path: <linux-kernel-owner+w=401wt.eu-S932473AbXBNTVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbXBNTVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932484AbXBNTVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:21:24 -0500
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:1818 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932473AbXBNTVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:21:24 -0500
Date: Wed, 14 Feb 2007 20:21:44 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dax Kelson <dax@gurulabs.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linus' laptop and Num lock status
Message-Id: <20070214202144.1ddb930f.khali@linux-fr.org>
In-Reply-To: <Pine.LNX.4.64.0702141104210.3604@woody.linux-foundation.org>
References: <1171479361.3706.48.camel@mentorng.gurulabs.com>
	<Pine.LNX.4.64.0702141104210.3604@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, 14 Feb 2007 11:12:23 -0800 (PST), Linus Torvalds wrote:
> On Wed, 14 Feb 2007, Dax Kelson wrote:
> > Are there any technical or political reasons why kernel can't change
> > from "force off" to "Follow BIOS"?
> 
> How would you query it? I'm not even 100% sure that you can on all 
> keyboards. We never query the leds, we always set them. I think. I don't 
> know of any AT kbd command to read the led state out of the keyboard.

On x86, the BIOS led state can be read from byte 0x97 the BIOS RAM. The
BIOS RAM is mapped at 0x400 so all we need to do is to one byte from
RAM (offset 0x497). This is how Suse's hwinfo does.

But maybe the first question to ask is: why is the BIOS setting lost in
the first place? Why is the kernel resetting the led state?

-- 
Jean Delvare
