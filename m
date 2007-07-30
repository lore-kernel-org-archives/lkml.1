Return-Path: <linux-kernel-owner+w=401wt.eu-S939691AbXG3Tts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939691AbXG3Tts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 15:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935738AbXG3Ttl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 15:49:41 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:54120 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936753AbXG3Ttj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 15:49:39 -0400
Date: Tue, 31 Jul 2007 04:48:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, linux-kernel@vger.kernel.org,
       Ondrej Zajicek <santiago@crfreenet.org>
Subject: Re: [PATCH] Framebuffer: Consolidated cleanup of pvr2fb.c for Sega Dreamcast
Message-ID: <20070730194854.GA29181@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	"Antonino A. Daplas" <adaplas@gmail.com>,
	linux-kernel@vger.kernel.org,
	Ondrej Zajicek <santiago@crfreenet.org>
References: <8b67d60707281739l6fc544e9k5eb130ab6e426ad2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60707281739l6fc544e9k5eb130ab6e426ad2@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 01:39:51AM +0100, Adrian McMenamin wrote:
> This patch consolidates your earlier patch, some cleanup of the
> documentation and, crucially, some better handling of the pvr2
> registers based on more up to date information.
> 
> Testing shows that it seems to work pretty well at 16bpp, 24bpp and
> 32bpp - including proper rendering of the boot logo at all levels
> (previously this was a bit broken even at 16bpp) and giving white
> against black text. Really detailed testing (eg with X11) requires
> support for the maple bus - which isn't (currently - next project
> assuming this is okay) available, but I have no reason to think this
> is broken.
> 
> Incidentally, substituing DIRECTCOLOR for TRUECOLOR appears to break the driver.
> 
> Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>


This looks fine to me in any event. I can either wrap this up in my tree
or Tony can include it with his next set of updates if he has any other
concerns. Thanks, Adrian.

Acked-by: Paul Mundt <lethal@linux-sh.org>
