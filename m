Return-Path: <linux-kernel-owner+w=401wt.eu-S1764661AbXEVHLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764661AbXEVHLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 03:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756455AbXEVHL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 03:11:26 -0400
Received: from brick.kernel.dk ([80.160.20.94]:10240 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953AbXEVHL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 03:11:26 -0400
Date: Tue, 22 May 2007 09:08:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Define CONFIG_BOUNCE to avoid useless inclusion of bounce buffer  logic.
Message-ID: <20070522070858.GJ4705@kernel.dk>
References: <Pine.LNX.4.64.0705212100420.24947@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705212100420.24947@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21 2007, Christoph Lameter wrote:
> The bounce buffer logic is included on systems that do not need it.
> If a system does not have zones like ZONE_DMA and ZONE_HIGHMEM that
> can lead to the use of bounce buffers then there is no need to reserve 
> memory pools etc etc. This is true f.e. for SGI Altix.
> 
> Also nicifies the Makefile and gets rid of the tricky "and" there.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

