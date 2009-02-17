Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbZBQXYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbZBQXYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 18:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbZBQXYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 18:24:00 -0500
Received: from outbound-mail-05.bluehost.com ([69.89.21.15]:59296 "HELO
	outbound-mail-05.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754027AbZBQXX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 18:23:59 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=GwgUpwIWDCG4epwa0SJ1SNvlvF3FkHCLoM8Eb5Wd0RfpP01++o4dz8ZGjYyiv4UcmBUnJ33boORCIHpw/kFS1oO0JqH6l9oY3C8vl6lXqCwsrmEfL0xOptOxrhniRAfN;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [Bug #12705] X200: Brightness broken since 2.6.29-rc4-58-g4c098bc
Date: Tue, 17 Feb 2009 15:23:57 -0800
User-Agent: KMail/1.9.10
Cc: Eric Anholt <eric.anholt@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Len Brown <lenb@kernel.org>,
       Nico Schottelius <nico-linux-20090213@schottelius.org>
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <1234911925.9844.89.camel@gaiman> <20090217231313.GA2654@srcf.ucam.org>
In-Reply-To: <20090217231313.GA2654@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902171523.57612.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 17, 2009 3:13 pm Matthew Garrett wrote:
> On Tue, Feb 17, 2009 at 03:05:25PM -0800, Eric Anholt wrote:
> > On Sun, 2009-02-15 at 13:43 +0000, Matthew Garrett wrote:
> > > On Sat, Feb 14, 2009 at 09:38:23PM +0100, Rafael J. Wysocki wrote:
> > > > The following bug entry is on the current list of known regressions
> > > > from 2.6.28.  Please verify if it still should be listed and let me
> > > > know (either way).
> > >
> > > I think Eric sent a test patch for this. Did that get pushed?
> >
> > I haven't done anything in the area of brightness control.
>
> This was drm failing to initialise because of incorrect mtrr setup and
> opregion not working as a result.

I sent one out; it just made the ioremap in i915_initialize into an ioremap_wc 
for consistency.

-- 
Jesse Barnes, Intel Open Source Technology Center
