Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbZGHSMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbZGHSMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 14:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbZGHSMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 14:12:39 -0400
Received: from verein.lst.de ([213.95.11.210]:55600 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329AbZGHSMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 14:12:38 -0400
Date: Wed, 8 Jul 2009 20:12:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH] virtio_blk: ioctl return value fix
Message-ID: <20090708181220.GB10552@lst.de>
References: <20090620192941.GA26873@lst.de> <200906231643.10623.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906231643.10623.rusty@rustcorp.com.au>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 04:43:10PM +0930, Rusty Russell wrote:
> On Sun, 21 Jun 2009 04:59:41 am Christoph Hellwig wrote:
> > Block driver ioctl methods must return ENOTTY and not -ENOIOCTLCMD if
> > they expect the block layer to handle generic ioctls.
> >
> > This triggered a BLKROSET failure in xfsqa #200.
> 
> Applied.

Can you send on this fix to Linus?  It fixes a regression introduced in
Linux 2.6.30.

