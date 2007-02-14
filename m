Return-Path: <linux-kernel-owner+w=401wt.eu-S932489AbXBNTMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbXBNTMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932449AbXBNTMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:12:44 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40253 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932489AbXBNTMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:12:43 -0500
Date: Wed, 14 Feb 2007 11:12:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dax Kelson <dax@gurulabs.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: Linus' laptop and Num lock status
In-Reply-To: <1171479361.3706.48.camel@mentorng.gurulabs.com>
Message-ID: <Pine.LNX.4.64.0702141104210.3604@woody.linux-foundation.org>
References: <1171479361.3706.48.camel@mentorng.gurulabs.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Feb 2007, Dax Kelson wrote:
> 
> Are there any technical or political reasons why kernel can't change
> from "force off" to "Follow BIOS"?

How would you query it? I'm not even 100% sure that you can on all 
keyboards. We never query the leds, we always set them. I think. I don't 
know of any AT kbd command to read the led state out of the keyboard.

		Linus
