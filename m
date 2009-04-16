Return-Path: <linux-kernel-owner+w=401wt.eu-S1753021AbZDPIfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbZDPIfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 04:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZDPIfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 04:35:01 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:55317 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZDPIfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 04:35:00 -0400
Date: Thu, 16 Apr 2009 17:30:00 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Zankel <chris@zankel.net>, Johannes Weiner <jw@emlix.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Xtensa patches
Message-ID: <20090416083000.GA30805@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Zankel <chris@zankel.net>, Johannes Weiner <jw@emlix.com>,
	linux-kernel@vger.kernel.org
References: <1239702080-14355-1-git-send-email-jw@emlix.com> <49E6E155.6090000@zankel.net> <20090416012447.fd6e6dee.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416012447.fd6e6dee.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 01:24:47AM -0700, Andrew Morton wrote:
> On Thu, 16 Apr 2009 00:42:13 -0700 Chris Zankel <chris@zankel.net> wrote:
> 
> > Hi Andrew,
> > 
> > I will look over those patches and commit them to xtensa-2.6.
> > 
> 
> OK.  I have a random pile if i-dont-know-what xtensa stuff here.
> 
> xtensa-add-flat-support-checkpatch-fixes.patch
> xtensa-variant-specific-code.patch
> xtensa-cache-inquiry-and-unaligned-cache-handling-functions.patch
> xtensa-s6000-dma-engine-support.patch
> xtensa-allow-platform-and-variant-to-initialize-own-irq-chips.patch
> xtensa-support-s6000-gpio-irqs-and-alternate-function-selection.patch
> s6gmac-xtensa-s6000-on-chip-ethernet-driver.patch
> s6gmac-xtensa-s6000-on-chip-ethernet-driver-fix.patch
> xtensa-s6105-specific-configuration-for-s6gmac.patch
> xtensa-enable-s6gmac-in-s6105_defconfig.patch
> xtensa-add-m41t62-rtc-to-s6105-platform.patch
> xtensa-enable-m41t80-driver-in-s6105_defconfig.patch
> 
> I'll drop xtensa-add-flat-support-checkpatch-fixes.patch (as I usually
> do when someone merges the base patch but doesn't run checkpatch on it
> - hint) and I'll send the rest over at you.
> 
Presumably the nommu xtensa bits still depend on

flat-fix-data-sections-alignment.patch

?
