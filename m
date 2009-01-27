Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558AbZA0FBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbZA0FBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 00:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbZA0FA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 00:00:59 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42810
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750717AbZA0FA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 00:00:58 -0500
Date: Mon, 26 Jan 2009 21:00:55 -0800 (PST)
Message-Id: <20090126.210055.104964648.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: iws@ovro.caltech.edu, linux-kernel@vger.kernel.org, markmc@redhat.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH] virtio_net: use correct accessors for scatterlists
From: David Miller <davem@davemloft.net>
In-Reply-To: <200901271521.19616.rusty@rustcorp.com.au>
References: <20090124001053.GA20156@ovro.caltech.edu>
	<200901271521.19616.rusty@rustcorp.com.au>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Tue, 27 Jan 2009 15:21:19 +1030

> On Saturday 24 January 2009 10:40:53 Ira Snyder wrote:
> > Without this fix, virtio_net makes incorrect usage of scatterlists. It sets
> > the end of the scatterlist chain after the first element, despite the fact
> > that more entries come after it.
> > 
> > If you try to run dma_map_sg() on one of the scatterlists given to you by
> > add_buf(), you will get a null pointer oops.
> > 
> > Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
> 
> Thanks, this should go in 2.6.29.  Dave?

Applied, should I queue it up for -stable too Rusty?

Thanks.
