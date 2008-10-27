Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbYJ0M5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbYJ0M5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 08:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYJ0M5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 08:57:32 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47194 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbYJ0M5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 08:57:32 -0400
Date: Mon, 27 Oct 2008 13:56:24 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, jeremy@xensource.com
Subject: Re: [PATCH 1/3] block: add queue flag for paravirt frontend drivers
Message-ID: <20081027125624.GA22217@kernel.dk>
References: <1219754894.7235.44.camel@sebastian.kern.oss.ntt.co.jp> <20080826143900.GM20055@kernel.dk> <1219814047.18991.52.camel@sebastian.kern.oss.ntt.co.jp> <1225100686.7370.79.camel@sebastian.kern.oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1225100686.7370.79.camel@sebastian.kern.oss.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27 2008, Fernando Luis Vázquez Cao wrote:
> As is the case with SSD devices, we do not want to idle in AS/CFQ when
> the block device is a paravirt front-end driver. This patch adds a flag
> (QUEUE_FLAG_VIRT) which should be used by front-end drivers such as
> virtio_blk and xen-blkfront to indicate a paravirtualized device.

All three patches look fine, although we could just reuse
QUEUE_FLAG_NONROT directly. But I agree it makes sense to make the
distinction, so I've just applied 1-3.

-- 
Jens Axboe

