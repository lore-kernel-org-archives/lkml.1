Return-Path: <linux-kernel-owner+w=401wt.eu-S1757820AbZFJP2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820AbZFJP2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 11:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755976AbZFJP2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 11:28:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38778 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728AbZFJP2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 11:28:10 -0400
Date: Wed, 10 Jun 2009 11:28:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: tom.leiming@gmail.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] init/do_mounts.c: replace polling for root device
	with devtmpfs_wait_for_dev
Message-ID: <20090610152811.GA21888@infradead.org>
References: <1244644097-305-1-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244644097-305-1-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 10:28:17PM +0800, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> This patch removes the polling for root device if rootwait parameter is
> passed to kernel and CONFIG_DEVTMPFS is enabled. This way can lead to
> a faster boot, especially booting from some asynchronous block device
> (such as usb mass storage, mmc card, ...)
> 
> The patch has been verified in beagle board(mmc card as root device).

What tree did you find with devtmpfs in it?  It was pretty clearly
rejected when it came up.

