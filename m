Return-Path: <linux-kernel-owner+w=401wt.eu-S1422858AbXBANKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422858AbXBANKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422857AbXBANKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:10:49 -0500
Received: from styx.suse.cz ([82.119.242.94]:58114 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422858AbXBANKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:10:48 -0500
Date: Thu, 1 Feb 2007 14:13:57 +0100
From: Jiri Bohac <jbohac@suse.cz>
To: Andi Kleen <ak@suse.de>
Cc: jbohac@suse.cz, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 2/9] Remove the support for the VXTIME_PMTMR timer mode
Message-ID: <20070201131353.GL21755@dwarf.suse.cz>
References: <20070201095952.589234000@jet.suse.cz> <20070201103753.508377000@jet.suse.cz> <200702011213.32278.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702011213.32278.ak@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 12:13:31PM +0100, Andi Kleen wrote:
> On Thursday 01 February 2007 10:59, jbohac@suse.cz wrote:
> > VXTIME_PMTMR will be replaced by a more generic "Master Timer"
> 
> This means we have no fallback if something goes wrong with the Master timer? 
> 
> A little risky.

No, either HPET or PM Timer will become the Master Timer (elected
on boot). Master timer is just an abstraction of these, so the
rest of the timekeeping code needn't care which hardware timer is
being used. That's why the VXTIME_PMTMR mode is not needed.

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

