Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbYAVX7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbYAVX7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 18:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYAVX70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 18:59:26 -0500
Received: from waste.org ([66.93.16.53]:45451 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbYAVX7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 18:59:25 -0500
Subject: Re: [PATCH rc8-mm1] hotfix libata-scsi corruption
From: Matt Mackall <mpm@selenic.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0801222241460.30816@blonde.site>
References: <Pine.LNX.4.64.0801221706320.5832@blonde.site>
	 <1201022985.3210.24.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801221813540.8693@blonde.site>
	 <1201031028.3210.61.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801222009070.16267@blonde.site>
	 <1201039931.3210.96.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0801222241460.30816@blonde.site>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 17:58:54 -0600
Message-Id: <1201046335.14436.92.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-22 at 22:59 +0000, Hugh Dickins wrote:
> On Tue, 22 Jan 2008, James Bottomley wrote:
> > 
> > libsas looks to be OK because it specifically kmallocs a 512 byte buffer
> > which should (for off slab data) be 512 byte aligned.
> 
> I don't remember the various SLAB and SLOB and SLUB rules offhand:
> I'm not sure it's safe to rely on such alignment on all of them ....

It doesn't work that way with SLOB kmalloc (nor did it in pre-slabified
kmalloc). One shouldn't be surprised if a SLAB/SLUB debugging feature
breaks that alignment either.

-- 
Mathematics is the supreme nostalgia of our time.

