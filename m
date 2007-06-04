Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbXFDNNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbXFDNNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbXFDNNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:13:05 -0400
Received: from twin.jikos.cz ([213.151.79.26]:33540 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233AbXFDNNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:13:01 -0400
Date: Mon, 4 Jun 2007 15:12:57 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Pavel Machek <pavel@ucw.cz>
cc: kernel list <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
In-Reply-To: <20070604130903.GC1971@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0706041511010.29896@twin.jikos.cz>
References: <20070604112426.GA2707@elf.ucw.cz> <Pine.LNX.4.64.0706041434040.29896@twin.jikos.cz>
 <20070604130903.GC1971@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Pavel Machek wrote:

> CONFIG_BLINK=y
> OOps. WTF is that?
> 
> config BLINK
> 	tristate "Keyboard blink driver"
> 	help
> 	  Driver that when loaded will blink the keyboard LEDs
> continuously.
> 	  This is useful for debugging and for kernels that cannot
> necessarily
> 	  output something to the screen like kexec kernels to give
> the user
> 	  a visual indication that the kernel is doing something.
> ..does it need "default n"? Why does it make keys stuck sometimes?

Are you sure that it's this dummy blink driver that makes the kernel 
stuck? I can't see how it could be causing any hogs - see commit f038f9.

Anyway, added Andi to CC.

-- 
Jiri Kosina
