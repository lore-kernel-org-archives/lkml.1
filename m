Return-Path: <linux-kernel-owner+w=401wt.eu-S1423182AbXBBHVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423182AbXBBHVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 02:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423172AbXBBHVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 02:21:34 -0500
Received: from cantor.suse.de ([195.135.220.2]:44755 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422973AbXBBHV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 02:21:27 -0500
From: Andi Kleen <ak@suse.de>
To: Jiri Bohac <jbohac@suse.cz>
Subject: Re: [patch 4/9] Remove the TSC synchronization on SMP machines
Date: Fri, 2 Feb 2007 08:13:27 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       ssouhlal@freebsd.org, arjan@infradead.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org, andrea@suse.de
References: <20070201095952.589234000@jet.suse.cz> <200702011214.24126.ak@suse.de> <20070201131715.GM21755@dwarf.suse.cz>
In-Reply-To: <20070201131715.GM21755@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702020813.28001.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 February 2007 14:17, Jiri Bohac wrote:
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

It's still useful as a double check for platforms (like Intel single node) 
which are supposed to be synchronized.
 
> Synchronizing it will not make anything better in any way -- the
> implementation just does not care whether TSCs are synchronized.
> That's why I think the synchronization code is not needed.

It doesn't actively synchronize it, just checks if they look synchronized.

-Andi 
