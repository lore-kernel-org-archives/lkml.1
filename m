Return-Path: <linux-kernel-owner+w=401wt.eu-S1030593AbXBAPRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030593AbXBAPRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:17:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030594AbXBAPRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:17:07 -0500
Received: from styx.suse.cz ([82.119.242.94]:33692 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030593AbXBAPRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:17:06 -0500
Date: Thu, 1 Feb 2007 16:16:54 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Jiri Bohac <jbohac@suse.cz>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       ssouhlal@freebsd.org, arjan@infradead.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 4/9] Remove the TSC synchronization on SMP machines
Message-ID: <20070201151654.GA20385@suse.cz>
References: <20070201095952.589234000@jet.suse.cz> <20070201103753.753349000@jet.suse.cz> <200702011214.24126.ak@suse.de> <20070201131715.GM21755@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070201131715.GM21755@dwarf.suse.cz>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 02:17:15PM +0100, Jiri Bohac wrote:
> On Thu, Feb 01, 2007 at 12:14:23PM +0100, Andi Kleen wrote:
> > On Thursday 01 February 2007 10:59, jbohac@suse.cz wrote:
> > > TSC is either synchronized by design or not reliable
> > > to be used for anything, let alone timekeeping.
> > 
> > In my tree this is already done better by a patch from Ingo.
> > Check if they look synchronized and don't use TSC if they are not.
> 
> The whole purpose of this patchset is to make use of TSC even if
> it's not synchronized.
> 
> Synchronizing it will not make anything better in any way -- the
> implementation just does not care whether TSCs are synchronized.
> That's why I think the synchronization code is not needed.
 
It might even make sense to desycnhronize the TSCs on such (AMD)
machines on purpose, so that applications that rely on TSC break
immediately and not after some time when the error becomes too large.

-- 
Vojtech Pavlik
Director SuSE Labs
