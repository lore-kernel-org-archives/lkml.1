Return-Path: <linux-kernel-owner+w=401wt.eu-S1756392AbYGGW5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbYGGW5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbYGGW5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:57:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:48286 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067AbYGGW5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:57:04 -0400
Subject: Re: [PATCH 1/2] elf loader support for auxvec base platform string
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andreas Schwab <schwab@suse.de>
Cc: Roland McGrath <roland@redhat.com>, Nathan Lynch <ntl@pobox.com>,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <je63rirp1x.fsf@sykes.suse.de>
References: <20080703234140.GC9594@localdomain>
	 <20080704021929.5E9EF1541F5@magilla.localdomain>
	 <1215409693.8970.79.camel@pasglop>
	 <20080707061811.19989154246@magilla.localdomain>
	 <1215411800.8970.91.camel@pasglop>
	 <20080707063522.5FE55154246@magilla.localdomain>
	 <je8wwet9p6.fsf@sykes.suse.de>
	 <20080707093151.8798A154246@magilla.localdomain>
	 <je63rirp1x.fsf@sykes.suse.de>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 08:56:33 +1000
Message-Id: <1215471393.8970.157.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-07 at 12:01 +0200, Andreas Schwab wrote:
> Roland McGrath <roland@redhat.com> writes:
> 
> > There are 32 bits free now.  One can anticipate that reassigning a bit
> > would come up only after these are exhausted.  With prudent use, this
> > will take a very long time to happen.  Then the oldest CPU type string
> > might be retired to reuse its bit.  It seems unlikely that there will
> > be a single installation (root directory) that really needs to have
> > installed both a kernel optimized for the oldest CPU model known and a
> > kernel optimized for the newest CPU model known.
> 
> The kernel does not have to come from the same place as the root
> filesystem.  You may want to run a new kernel with an old filesystem, or
> vice-versa.

I agree, I'm pretty dubious here...

Cheers,
Ben.


