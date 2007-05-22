Return-Path: <linux-kernel-owner+w=401wt.eu-S933781AbXEVVon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781AbXEVVon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 17:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757314AbXEVVoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 17:44:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59921 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756275AbXEVVoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 17:44:34 -0400
Date: Tue, 22 May 2007 14:44:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Bernhard Walle <bwalle@suse.de>
cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] [scsi] Remove __GFP_DMA
In-Reply-To: <20070521151525.GA581@suse.de>
Message-ID: <Pine.LNX.4.64.0705221443030.16285@schroedinger.engr.sgi.com>
References: <20070521151525.GA581@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007, Bernhard Walle wrote:

> [PATCH] [scsi] Remove __GFP_DMA
> 
> After 821de3a27bf33f11ec878562577c586cd5f83c64, it's not necessary to alloate a
> DMA buffer any more in sd.c.
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>

Great that avoids a DMA kmalloc slab. Any other GFP_DMAs left in the scsi 
layer?

Acked-by: Christoph Lameter <clameter@sgi.com>
