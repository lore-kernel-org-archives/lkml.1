Return-Path: <linux-kernel-owner+w=401wt.eu-S1422859AbXBANOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422859AbXBANOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:14:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422860AbXBANOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:14:07 -0500
Received: from styx.suse.cz ([82.119.242.94]:58207 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422859AbXBANOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:14:06 -0500
Date: Thu, 1 Feb 2007 14:17:15 +0100
From: Jiri Bohac <jbohac@suse.cz>
To: Andi Kleen <ak@suse.de>
Cc: jbohac@suse.cz, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 4/9] Remove the TSC synchronization on SMP machines
Message-ID: <20070201131715.GM21755@dwarf.suse.cz>
References: <20070201095952.589234000@jet.suse.cz> <20070201103753.753349000@jet.suse.cz> <200702011214.24126.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702011214.24126.ak@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 12:14:23PM +0100, Andi Kleen wrote:
> On Thursday 01 February 2007 10:59, jbohac@suse.cz wrote:
> > TSC is either synchronized by design or not reliable
> > to be used for anything, let alone timekeeping.
> 
> In my tree this is already done better by a patch from Ingo.
> Check if they look synchronized and don't use TSC if they are not.

The whole purpose of this patchset is to make use of TSC even if
it's not synchronized.

Synchronizing it will not make anything better in any way -- the
implementation just does not care whether TSCs are synchronized.
That's why I think the synchronization code is not needed.

-- 
Jiri Bohac <jbohac@suse.cz>
SUSE Labs, SUSE CZ

