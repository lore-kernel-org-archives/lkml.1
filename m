Return-Path: <linux-kernel-owner+w=401wt.eu-S1422861AbXBANNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422861AbXBANNI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422860AbXBANNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:13:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32900 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422864AbXBANNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:13:06 -0500
From: Andi Kleen <ak@suse.de>
To: Jiri Bohac <jbohac@suse.cz>
Subject: Re: [patch 2/9] Remove the support for the VXTIME_PMTMR timer mode
Date: Thu, 1 Feb 2007 14:13:00 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       ssouhlal@freebsd.org, arjan@infradead.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org, andrea@suse.de
References: <20070201095952.589234000@jet.suse.cz> <200702011213.32278.ak@suse.de> <20070201131353.GL21755@dwarf.suse.cz>
In-Reply-To: <20070201131353.GL21755@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702011413.00623.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 February 2007 14:13, Jiri Bohac wrote:
> On Thu, Feb 01, 2007 at 12:13:31PM +0100, Andi Kleen wrote:
> > On Thursday 01 February 2007 10:59, jbohac@suse.cz wrote:
> > > VXTIME_PMTMR will be replaced by a more generic "Master Timer"
> > 
> > This means we have no fallback if something goes wrong with the Master timer? 
> > 
> > A little risky.
> 
> No, either HPET or PM Timer will become the Master Timer (elected
> on boot). Master timer is just an abstraction of these, so the
> rest of the timekeeping code needn't care which hardware timer is
> being used. That's why the VXTIME_PMTMR mode is not needed.

But there is no option for the user to force so, is there?

-Andi

