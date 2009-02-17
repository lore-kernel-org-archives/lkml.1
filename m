Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbZBQXN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbZBQXN3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbZBQXNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:13:20 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:57793 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbZBQXNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:13:19 -0500
Date: Tue, 17 Feb 2009 23:13:13 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Eric Anholt <eric.anholt@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Len Brown <lenb@kernel.org>,
       Nico Schottelius <nico-linux-20090213@schottelius.org>
Subject: Re: [Bug #12705] X200: Brightness broken since 2.6.29-rc4-58-g4c098bc
Message-ID: <20090217231313.GA2654@srcf.ucam.org>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.htD.Sr0lJB@chimera> <20090215134347.GB21670@srcf.ucam.org> <1234911925.9844.89.camel@gaiman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234911925.9844.89.camel@gaiman>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 03:05:25PM -0800, Eric Anholt wrote:
> On Sun, 2009-02-15 at 13:43 +0000, Matthew Garrett wrote:
> > On Sat, Feb 14, 2009 at 09:38:23PM +0100, Rafael J. Wysocki wrote:
> > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.28.  Please verify if it still should be listed and let me know
> > > (either way).
> > 
> > I think Eric sent a test patch for this. Did that get pushed?
> 
> I haven't done anything in the area of brightness control.

This was drm failing to initialise because of incorrect mtrr setup and 
opregion not working as a result.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
