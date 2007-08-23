Return-Path: <linux-kernel-owner+w=401wt.eu-S1757066AbXHWBka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbXHWBka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 21:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbXHWBkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 21:40:17 -0400
Received: from mail.suse.de ([195.135.220.2]:36403 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbXHWBkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 21:40:15 -0400
Date: Thu, 23 Aug 2007 04:34:04 +0200
From: Andi Kleen <ak@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>,
       James Courtier-Dutton <James@superbug.demon.co.uk>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
Message-ID: <20070823023404.GL8058@bingen.suse.de>
References: <46CBC842.4070100@vmware.com> <46CCB088.8070606@goop.org> <46CCB56F.8090308@superbug.co.uk> <20070822222036.GD3672@sequoia.sous-sol.org> <46CCB8BA.6060007@superbug.demon.co.uk> <46CCC361.6020600@goop.org> <20070823004700.GR2642@bingen.suse.de> <46CCD707.1090009@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CCD707.1090009@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 05:38:31PM -0700, Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > On Wed, Aug 22, 2007 at 04:14:41PM -0700, Jeremy Fitzhardinge wrote:
> >   
> >> (which would also have VT, since
> >> all new processors do).
> >>     
> >
> > Not true unfortunately. The Intel low end parts like Celerons (which 
> > are actually shipped in very large numbers) don't. Also Intel
> > is still shipping some CPUs that don't support it at all, like
> > the ULV Centrinos which are based on an older core.
> >   
> 
> Likely to be missing VT-d too, right?

VT-d is chipset functionality. So it depends on the chipset.

At least initially the non Intel chipsets and lowend chips are unlikely
to get IOMMUs I guess.

There might be some exceptions. e.g. the GPU vendors seem
to want to to their own IOMMUs, so perhaps graphic devices
might have them anyways.

-Andi
