Return-Path: <linux-kernel-owner+w=401wt.eu-S1763798AbZDHJg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763798AbZDHJg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 05:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbZDHJgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 05:36:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41330 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZDHJgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 05:36:18 -0400
Date: Wed, 8 Apr 2009 11:38:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [2/16] POISON: Add page flag for poisoned pages
Message-ID: <20090408093834.GJ17934@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org> <20090407150958.BA68F1D046D@basil.firstfloor.org> <20090407221421.890f27a6.akpm@linux-foundation.org> <20090408062441.GF17934@one.firstfloor.org> <20090408000018.9567a5fa.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408000018.9567a5fa.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 12:00:18AM -0700, Andrew Morton wrote:
> On Wed, 8 Apr 2009 08:24:41 +0200 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > On Tue, Apr 07, 2009 at 10:14:21PM -0700, Andrew Morton wrote:
> > > On Tue,  7 Apr 2009 17:09:58 +0200 (CEST) Andi Kleen <andi@firstfloor.org> wrote:
> > > 
> > > > Poisoned pages need special handling in the VM and shouldn't be touched 
> > > > again. This requires a new page flag. Define it here.
> > > 
> > > I wish this patchset didn't change/abuse the well-understood meaning of
> > > the word "poison".
> > 
> > Sorry, that's the terminology on the hardware side.
> > 
> > If there's much confusion I could rename it HwPoison or somesuch?
> 
> I understand that'd be a PITA but I suspect it would be best,
> long-term.  Having this conflict in core MM is really pretty bad.

Ok. I'll rename it to HWPoison().

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
