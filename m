Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZCNUua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZCNUua (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 16:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZCNUuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 16:50:21 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41096 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751793AbZCNUuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 16:50:20 -0400
Subject: Re: [PATCH 03/10] ide: destroy DMA mappings after ending DMA
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Grant Grundler <grundler@google.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <da824cf30903141345l55f51571u92e0d5787aa61d7d@mail.gmail.com>
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain>
	 <20090220171201.25429.29473.sendpatchset@localhost.localdomain>
	 <da824cf30903140012g1565696kd6c69b4cd513f15b@mail.gmail.com>
	 <200903142051.57971.bzolnier@gmail.com>
	 <da824cf30903141345l55f51571u92e0d5787aa61d7d@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 15:50:16 -0500
Message-Id: <1237063816.3907.70.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-03-14 at 21:45 +0100, Grant Grundler wrote:
> On Sat, Mar 14, 2009 at 8:51 PM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> ...
> >> I can create separate patches for both. Which git tree should I base
> >> them against?
> >
> > linux-next git tree
> > (or pata-2.6 quilt tree)
> 
> I've not used quilt yet and can only deal with git in a very crude way.
> Thanks for the references!

Have no fear ... you just rsync the quilt to a directory (~/pata_quilt
or something) on any server (use rsync so you only pick up the diffs
next time around) and then do

git quiltimport --patches ~/pata_quilt

and voila: a git tree ... of course it's a new one, and it's much harder
to handle incremental quilts (quilts that just have an extra few patches
added) since git rebuilds the entire tree with a different commitid for
each patch every time.

James


