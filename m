Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbXFDNJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbXFDNJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbXFDNJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:09:11 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33315 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751119AbXFDNJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:09:10 -0400
Date: Mon, 4 Jun 2007 15:09:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jikos@jikos.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?
Message-ID: <20070604130903.GC1971@elf.ucw.cz>
References: <20070604112426.GA2707@elf.ucw.cz> <Pine.LNX.4.64.0706041434040.29896@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706041434040.29896@twin.jikos.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-06-04 14:35:23, Jiri Kosina wrote:
> On Mon, 4 Jun 2007, Pavel Machek wrote:
> 
> > I started getting blinking capslock leds in 2.6.22-somewhere. Every 5 
> > seconds or so, capslock led toggles on thinkpad x60. Ouch. I also get 
> > some stuck keys I was not getting before. I hope my userland did not go 
> > crazy...
> 
> Hi Pavel,
> 
> what does
> 
> 	grep BLINK .config
> show.

CONFIG_BLINK=y

OOps. WTF is that?

config BLINK
	tristate "Keyboard blink driver"
	help
	  Driver that when loaded will blink the keyboard LEDs
continuously.
	  This is useful for debugging and for kernels that cannot
necessarily
	  output something to the screen like kexec kernels to give
the user
	  a visual indication that the kernel is doing something.


..does it need "default n"? Why does it make keys stuck sometimes?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
