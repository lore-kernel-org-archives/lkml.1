Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbYHNDKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbYHNDKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 23:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751137AbYHNDKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 23:10:05 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:31861 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750995AbYHNDKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 23:10:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vd0lnMCholJCeyEkNeEzoAL7wNUEkv+W4k9Ka2kBXq/8UwBDuHnumkb1DgRHneIlL4kbckwZwvJAm2UCfUtWjeCb+IGwB72x/6DuXKJJFpautMs1hULQXFpEvgSQIFrbIZTz4pNoHtTMa9DOVMja3ffumvdtqopZhf6rl139OAQ=  ;
X-YMail-OSG: XsuDyyIVM1k9Qk5sHAZWL7fjEU2Rx8f47Xydv_4xnFZ9b5QGISNSuMYXw6gkFxn_iXGneTavzYgn1uGAmnOPID4fb3ZH1dsnI2HLwDIy0b0oWl.5R4BAIcAt1N720vlMgG9Al_akPfWhjNg.FWMS4pTt
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] USB patches for 2.6.27-rc3
Date: Wed, 13 Aug 2008 20:10:00 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <20080814004412.GA17255@suse.de>
In-Reply-To: <20080814004412.GA17255@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808132010.00786.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 August 2008, Greg KH wrote:
> The majority of this patch is removing an old driver (auerswald), and
> adding a new one (musb, an USB embedded host/device combo on ARM
> systems).  musb is totally self-contained, so that causes no problems
> with any other patches.

Minor clarifications.  The musb_hdrc (*) driver is *currently* used on ARM,
specifically a bunch of TI chips (**), but it's an IP core which has been
licensed by various other vendors.  That is:  it's not ARM-specific.

We already know about work adding Blackfin 5xx support, which I suspect
will appear in the 2.6.28 timeframe, and I've also had queries from folk
using this IP on some PowerPC systems too.

- Dave

(*)  Mentor USB Highspeed Dual Role Controller (MUSB HDRC),
     from Mentor Graphics.  "USB On-The-Go" (OTG) support.

(**) DaVinci, OMAP2, OMAP3 (see beaglebord.org!), and the
     discrete chip used in Nokia 8x0 Linux tablets.
