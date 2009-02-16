Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbZBPBQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbZBPBQV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 20:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754749AbZBPBQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 20:16:10 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45439 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbZBPBQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 20:16:08 -0500
Date: Mon, 16 Feb 2009 01:16:00 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>,
       Thomas Renninger <trenn@suse.de>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [Bug #12401] 2.6.28 regression: xbacklight broken on ThinkPad X61s
Message-ID: <20090216011600.GA28929@srcf.ucam.org>
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <ROx6X68CGJG.A.FEB.M50lJB@chimera> <20090215134409.GC21670@srcf.ucam.org> <200902151538.29766.rjw@sisk.pl> <20090215221647.GA15392@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090215221647.GA15392@dose.home.local>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 15, 2009 at 11:16:47PM +0100, Tino Keitel wrote:

> I think if it works without DRI in 2.6.27 and doesn't work in 2.6.28,
> it isn't a configuration error, but a real regression.

It only worked by accident without DRM support, since you were using the 
ATI codepath in the firmware rather than the Intel one. That bug's been 
fixed, so now you're following the Intel codepath - unfortunately 
there's no way to do that without kernel-level graphics support, which 
means DRM.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
