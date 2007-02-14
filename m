Return-Path: <linux-kernel-owner+w=401wt.eu-S932487AbXBNTcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbXBNTcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 14:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932490AbXBNTcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 14:32:54 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41755 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932487AbXBNTcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 14:32:53 -0500
Date: Wed, 14 Feb 2007 11:32:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
cc: Dax Kelson <dax@gurulabs.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linus' laptop and Num lock status
In-Reply-To: <20070214202144.1ddb930f.khali@linux-fr.org>
Message-ID: <Pine.LNX.4.64.0702141130340.20368@woody.linux-foundation.org>
References: <1171479361.3706.48.camel@mentorng.gurulabs.com>
 <Pine.LNX.4.64.0702141104210.3604@woody.linux-foundation.org>
 <20070214202144.1ddb930f.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Feb 2007, Jean Delvare wrote:
> 
> On x86, the BIOS led state can be read from byte 0x97 the BIOS RAM. The
> BIOS RAM is mapped at 0x400 so all we need to do is to one byte from
> RAM (offset 0x497). This is how Suse's hwinfo does.

Heh. Shows just how much I ever used DOS and BIOS.

> But maybe the first question to ask is: why is the BIOS setting lost in
> the first place? Why is the kernel resetting the led state?

Ehh. Silly question. "Those flags, they do nothing."

The kernel needs to know what they are in order to react correctly to 
them. And since you can't read them from hardware, the only way to know 
what they are (if you don't know about BIOS magic areas) is to SET THEM.

Which is what the kernel has traditionally always done.

		Linus
