Return-Path: <linux-kernel-owner+w=401wt.eu-S2993120AbXCIPf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993120AbXCIPf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 10:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993119AbXCIPf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 10:35:28 -0500
Received: from cavan.codon.org.uk ([217.147.92.49]:43367 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993121AbXCIPf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 10:35:26 -0500
Date: Fri, 9 Mar 2007 15:34:58 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Johnson <ajohnson@intrinsyc.com>, linux-kernel@vger.kernel.org
Message-ID: <20070309153456.GA28664@srcf.ucam.org>
References: <1173394485.28589.17.camel@localhost.localdomain> <20070309090805.GA5822@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309090805.GA5822@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [PATCH] Software Suspend: Fix suspend when console is in VT_AUTO/KD_GRAPHICS mode
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 10:08:05AM +0100, Pavel Machek wrote:

> So... if current console is graphical, we leave X accessing the
> console... That's bad, because video state is not going to be
> restored...?

A graphical console is not necessarily X. Is there any requirement for 
there to be a single VT that isn't in text mode? The vt switching is 
a hack, we shouldn't make life difficult for people who have their own 
userspace code that's entirely capable of restoring video state on its 
own.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
