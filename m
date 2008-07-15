Return-Path: <linux-kernel-owner+w=401wt.eu-S1762927AbYGOUtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762927AbYGOUtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbYGOUtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:49:03 -0400
Received: from 1wt.eu ([62.212.114.60]:4010 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbYGOUtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:49:01 -0400
Date: Tue, 15 Jul 2008 22:47:50 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, Frans Pop <elendil@planet.nl>,
       arjan@infradead.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [GIT *] Allow request_firmware() to be satisfied from in-kernel, use it in more drivers.
Message-ID: <20080715204750.GM1369@1wt.eu>
References: <487C0365.5030203@garzik.org> <alpine.LFD.1.10.0807141911270.3017@woody.linux-foundation.org> <200807151757.10626.elendil@planet.nl> <1216149637.27242.65.camel@violet.holtmann.net> <alpine.LFD.1.10.0807151223290.3351@woody.linux-foundation.org> <1216150616.27455.377.camel@shinybook.infradead.org> <alpine.LFD.1.10.0807151244320.3351@woody.linux-foundation.org> <1216151640.27242.90.camel@violet.holtmann.net> <alpine.LFD.1.10.0807151301130.2867@woody.linux-foundation.org> <487D0801.4000206@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487D0801.4000206@garzik.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 04:26:41PM -0400, Jeff Garzik wrote:
> To be extremely concrete, firmware-in-module is
> 
> 	* add Kconfig option (kernel-wide or per-driver, dunno) asking
> 	  "build firmware into drivers, as before?"
> 
> 	* tweak build process to build firmware into foo.ko output,
> 	  probably in a specially marked ELF section
> 
> 	* get request_firmware() to automatically notice that the
> 	  MODULE_FIRMWARE() was built into this driver, and to
> 	  look at the special ELF section for its data

Jeff, just thinking, wouldn't it be slightly easier to move the firmware
in a separate module on its own and just add a dependency, so that foo.ko
automatically loads foo-fw.ko ? I know it will be slightly differente, but
would not change in-site deployment workflows nor installed scripts.

Regards,
Willy

