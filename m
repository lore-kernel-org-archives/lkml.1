Return-Path: <linux-kernel-owner+w=401wt.eu-S1422902AbXBAOVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422902AbXBAOVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 09:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422900AbXBAOVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 09:21:06 -0500
Received: from ns1.suse.de ([195.135.220.2]:42154 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422902AbXBAOVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 09:21:05 -0500
From: Andi Kleen <ak@suse.de>
To: Jiri Bohac <jbohac@suse.cz>
Subject: Re: [patch 2/9] Remove the support for the VXTIME_PMTMR timer mode
Date: Thu, 1 Feb 2007 15:18:47 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       ssouhlal@freebsd.org, arjan@infradead.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org, andrea@suse.de
References: <20070201095952.589234000@jet.suse.cz> <200702011413.00623.ak@suse.de> <20070201135936.GQ21755@dwarf.suse.cz>
In-Reply-To: <20070201135936.GQ21755@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702011518.47428.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 February 2007 14:59, Jiri Bohac wrote:
> On Thu, Feb 01, 2007 at 02:13:00PM +0100, Andi Kleen wrote:
> > On Thursday 01 February 2007 14:13, Jiri Bohac wrote:
> > > On Thu, Feb 01, 2007 at 12:13:31PM +0100, Andi Kleen wrote:
> > > > On Thursday 01 February 2007 10:59, jbohac@suse.cz wrote:
> > > > > VXTIME_PMTMR will be replaced by a more generic "Master Timer"
> > > > 
> > > > This means we have no fallback if something goes wrong with the Master timer? 
> > > > 
> > > > A little risky.
> > > 
> > > No, either HPET or PM Timer will become the Master Timer (elected
> > > on boot). Master timer is just an abstraction of these, so the
> > > rest of the timekeeping code needn't care which hardware timer is
> > > being used. That's why the VXTIME_PMTMR mode is not needed.
> > 
> > But there is no option for the user to force so, is there?
> 
> HPET is the default. If it's not available or with the "nohpet"
> commandline option, PM Timer will be used as the Master Timer. 

This assumes all your algorithms are always correct.
 
> If this is not enough, it can be easily fixed in time_init().

I think we want at least one option that forces HPET/PMtimer as primary
time source.

-Andi

 
