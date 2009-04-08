Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbZDHHD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbZDHHD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751435AbZDHHDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:03:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772AbZDHHDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:03:49 -0400
Date: Wed, 8 Apr 2009 00:00:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [2/16] POISON: Add page flag for poisoned pages
Message-Id: <20090408000018.9567a5fa.akpm@linux-foundation.org>
In-Reply-To: <20090408062441.GF17934@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org>
	<20090407150958.BA68F1D046D@basil.firstfloor.org>
	<20090407221421.890f27a6.akpm@linux-foundation.org>
	<20090408062441.GF17934@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009 08:24:41 +0200 Andi Kleen <andi@firstfloor.org> wrote:

> On Tue, Apr 07, 2009 at 10:14:21PM -0700, Andrew Morton wrote:
> > On Tue,  7 Apr 2009 17:09:58 +0200 (CEST) Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > Poisoned pages need special handling in the VM and shouldn't be touched 
> > > again. This requires a new page flag. Define it here.
> > 
> > I wish this patchset didn't change/abuse the well-understood meaning of
> > the word "poison".
> 
> Sorry, that's the terminology on the hardware side.
> 
> If there's much confusion I could rename it HwPoison or somesuch?

I understand that'd be a PITA but I suspect it would be best,
long-term.  Having this conflict in core MM is really pretty bad.

> > > The page flags wars seem to be over, so it shouldn't be a problem
> > > to get a new one. I hope.
> > 
> > They are?  How did it all get addressed?
> 
> Allowing 64bit to use more and using [V]SPARSEMAP to limit flags
> use for zones. I think.

Nobody ever seems to be able to work out how many we actually have
left.

