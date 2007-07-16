Return-Path: <linux-kernel-owner+w=401wt.eu-S1761959AbXGPUHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761959AbXGPUHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbXGPUG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:06:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60939 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753187AbXGPUGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:06:55 -0400
Date: Mon, 16 Jul 2007 13:06:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, ak@suse.de
Subject: Re: [PATCH 09/33] x86-64: update iommu/dma mapping functions to sg
 helpers
Message-Id: <20070716130608.4d096e29.akpm@linux-foundation.org>
In-Reply-To: <11845792681830-git-send-email-jens.axboe@oracle.com>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
	<11845792681830-git-send-email-jens.axboe@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007 11:47:23 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> This prepares x86-64 for sg chaining support.
> 
> Additional improvements/fixups for pci-gart from
> Benny Halevy <bhalevy@panasas.com>
> 
> Cc: ak@suse.de
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  arch/x86_64/kernel/pci-calgary.c |   25 ++++++++------
>  arch/x86_64/kernel/pci-gart.c    |   63 ++++++++++++++++++++-----------------
>  arch/x86_64/kernel/pci-nommu.c   |    5 ++-
>  3 files changed, 51 insertions(+), 42 deletions(-)

This causes fairly extensive destruction of 2.6.23 changes which are
pending in Andi's tree.

I shall drop the block tree until a) Andi has merged the pending Calgary
changes and b) the block tree has been fixed up to account for those (and
other) changes.

Really, this was the perfectly worst time possible to go tromping all over
everyone else's trees.

