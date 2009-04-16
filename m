Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbZDPJLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbZDPJLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 05:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754988AbZDPJLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 05:11:24 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:52367 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580AbZDPJLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 05:11:21 -0400
Date: Thu, 16 Apr 2009 18:06:23 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier.adi@gmail.com>
Cc: Chris Zankel <chris@zankel.net>, Johannes Weiner <jw@emlix.com>,
       linux-kernel@vger.kernel.org, Oskar Schirmer <os@emlix.com>,
       Greg Ungerer <gerg@snapgear.com>
Subject: Re: Xtensa patches
Message-ID: <20090416090623.GA30877@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Frysinger <vapier.adi@gmail.com>,
	Chris Zankel <chris@zankel.net>, Johannes Weiner <jw@emlix.com>,
	linux-kernel@vger.kernel.org, Oskar Schirmer <os@emlix.com>,
	Greg Ungerer <gerg@snapgear.com>
References: <1239702080-14355-1-git-send-email-jw@emlix.com> <49E6E155.6090000@zankel.net> <20090416012447.fd6e6dee.akpm@linux-foundation.org> <20090416083000.GA30805@linux-sh.org> <20090416015601.d4114f73.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416015601.d4114f73.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 01:56:01AM -0700, Andrew Morton wrote:
> On Thu, 16 Apr 2009 17:30:00 +0900 Paul Mundt <lethal@linux-sh.org> wrote:
> > On Thu, Apr 16, 2009 at 01:24:47AM -0700, Andrew Morton wrote:
> > > OK.  I have a random pile if i-dont-know-what xtensa stuff here.
> > > 
> > > xtensa-add-flat-support-checkpatch-fixes.patch
> > > xtensa-variant-specific-code.patch
> > > xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
> > > xtensa-s6000-dma-engine-support.patch
> > > xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
> > > xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
> > > s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
> > > s6gmac-xtensa-s6000-on-chip-ethernet-driver-fix.patch
> > > xtensa-s6105-specific-configuration-for-s6gmac.patch
> > > xtensa-enable-s6gmac-in-s6105_defconfig.patch
> > > xtensa-add-m41t62-rtc-to-s6105-platform.patch
> > > xtensa-enable-m41t80-driver-in-s6105_defconfig.patch
> > > 
> > > I'll drop xtensa-add-flat-support-checkpatch-fixes.patch (as I usually
> > > do when someone merges the base patch but doesn't run checkpatch on it
> > > - hint) and I'll send the rest over at you.
> > > 
> > Presumably the nommu xtensa bits still depend on
> > 
> > flat-fix-data-sections-alignment.patch
> > 
> > ?
> 
> I don't think I ever knew that.
> 
http://lkml.org/lkml/2009/4/9/241

> What's happening with flat-fix-data-sections-alignment.patch, btw?  It
> seems to be stuck.
> 
As far as I know it was just waiting on Mike to comment, as he was the
only other one with concerns. Mike?
