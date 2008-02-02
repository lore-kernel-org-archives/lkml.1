Return-Path: <linux-kernel-owner+w=401wt.eu-S1763877AbYBBEMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763877AbYBBEMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 23:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbYBBEMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 23:12:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:42731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbYBBEMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 23:12:13 -0500
Date: Sat, 2 Feb 2008 05:12:11 +0100
From: Andi Kleen <ak@suse.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andi Kleen <ak@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Are Section mismatches out of control?
Message-ID: <20080202041211.GA27735@bingen.suse.de>
References: <20080201104718.GA11717@uranus.ravnborg.org> <200802011210.52655.ak@suse.de> <Pine.LNX.4.64.0802012250251.18790@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802012250251.18790@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 10:51:14PM +0100, Jan Engelhardt wrote:
> 
> On Feb 1 2008 12:10, Andi Kleen wrote:
> >On Friday 01 February 2008 11:47:18 Sam Ravnborg wrote:
> >> James said in a related posting that the Section mismatch
> >> warnings were getting out of control.
> >
> >My question is: where are crashes? If the sections were
> >really in such bad shape and since we poison (and sometimes
> >even unmap) init after boot we should in theory see a lot 
> >of oops reports from this if there were really accesses to
> >them after boot.
> >
> >Where are they?
> 
> Perhaps still in RAM? Explicitly zero the area after unmapping,
> maybe something happens.

This is already doing (but not with zero). With DEBUG_RODATA it is 
even unmapped. 

-Andi

