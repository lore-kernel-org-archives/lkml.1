Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbZJBUc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbZJBUc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758032AbZJBUc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:32:58 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54801 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758029AbZJBUc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 16:32:57 -0400
Date: Fri, 2 Oct 2009 16:32:41 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       Nelson Elhage <nelhage@ksplice.com>
Subject: Re: [PATCH 2/2] arm: Clean up linker script using new linker	script
 macros.
In-Reply-To: <20091001125657.GA26910@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.1.10.0910021536510.19358@dr-wily.mit.edu>
References: <1254345935-15958-1-git-send-email-tabbott@ksplice.com> <1254345935-15958-3-git-send-email-tabbott@ksplice.com> <20090930213924.GB15732@merkur.ravnborg.org> <20091001125657.GA26910@n2100.arm.linux.org.uk>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009, Russell King - ARM Linux wrote:

> On Wed, Sep 30, 2009 at 11:39:25PM +0200, Sam Ravnborg wrote:
> > 
> > Where is _end in the new layout?
> > I think we lost it.
> 
> You're right - this will cause a build failure since _end is used in
> several core ARM files.  Tim?

It's supposed to be after BSS_SECTION.  I'll send you a new pair of 
patches with this fixed and Sam's acks added shortly.

> PS, please ensure that all patches are at the very least build tested,
> or say when they aren't.

These were build-tested originally; it seems I introduced this bug when 
rebasing the patch past the recent DISCARD changes, and failed to retest.  
Sorry about that (I think you are right that it was more generally a 
mistake to not clearly tag these patches as build-but-not-run tested in 
the first place.  I'll do that in the future).

My cross-compile environment is unavailable at present, so the new version 
will be completely untested as well.

	-Tim Abbott


