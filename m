Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbYDHPIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbYDHPIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 11:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbYDHPIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 11:08:10 -0400
Received: from mjg.x.mythic-beasts.com ([93.93.128.6]:35543 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbYDHPIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:08:09 -0400
X-Greylist: delayed 1575 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Apr 2008 11:08:08 EDT
Date: Tue, 8 Apr 2008 15:41:12 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Romano Giannetti <romanol@upcomillas.es>
Cc: Tino Keitel <tino.keitel@gmx.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org, Jesse Barnes <jesse.barnes@intel.com>,
       suspend-devel@lists.sourceforge.net
Message-ID: <20080408144112.GA18580@srcf.ucam.org>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <1207290689.4511.1.camel@localhost> <1207552602.26185.13.camel@pern> <200804071110.39933.rjw@sisk.pl> <20080408085846.GA15403@dose.home.local> <1207658107.21698.17.camel@pern>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207658107.21698.17.camel@pern>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: 2.6.25-rc6 regression - hang on resume [Bug 10319]
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2008 at 02:35:07PM +0200, Romano Giannetti wrote:

> So, people with a working suspend-to-ram setup (even using the whitelist
> in s2ram, I mean, simply calling s2ram) will discover that 2.6.25 break
> their machine. Removing the s2ram package and suspending with
> kernel-only machinery will work, but... well, it's not user-friendly.

The assumption that a static table of VBE-based quirks can be used 
without paying attention to the capabilities of the video driver has 
always been broken, though I'll freely admit that it's all my fault in 
the first place...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
