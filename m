Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbYGBSyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbYGBSyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 14:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbYGBSyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 14:54:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55309 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbYGBSyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 14:54:08 -0400
Date: Wed, 2 Jul 2008 11:51:45 -0700
From: Greg KH <greg@kroah.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Nathan Lynch <ntl@pobox.com>, Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Is sysfs the right place to get cache and CPU topology info?
Message-ID: <20080702185145.GB20938@kroah.com>
References: <18539.8141.683072.967851@cargo.ozlabs.ibm.com> <20080702003755.4daff613.akpm@linux-foundation.org> <87r6acsfo1.fsf@basil.nowhere.org> <20080702143554.GY9594@localdomain> <486B9B3A.4060709@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486B9B3A.4060709@firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 05:14:02PM +0200, Andi Kleen wrote:
> Nathan Lynch wrote:
> > Andi Kleen wrote:
> >> Andrew Morton <akpm@linux-foundation.org> writes:
> >>> sysfs is part of the kernel ABI.  We should design our interfaces there
> >>> as carefully as we design any others.
> >> The basic problem is that sysfs exports an internal kernel object model
> >> and these tend to change. To really make it stable would require 
> >> splitting it into internal and presented interface.
> > 
> > True, but... /sys/devices/system/cpu has been there since around 2.6.5
> > iirc.  A google code search for that path shows plenty of programs
> > (including hal) that hard-code it.  Exposed object model or not,
> > changing that path would break lots of software.
> 
> Yes it would.
> 
> But Greg is making noises of getting rid of sysdevs and it wouldn't
> surprise me if that ended up being user visible since most object
> model changes end up being visible.

I hope to make sysdevs go away in such a manner that the sysfs tree does
not change at all.  That's my goal, but we still have a long ways to go
before we can even consider attempting to do this, so don't worry about
putting things in this location if you feel it is the best fit.

thanks,

greg k-h
