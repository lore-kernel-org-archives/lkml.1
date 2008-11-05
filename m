Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbYKEJWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbYKEJWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYKEJVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:21:53 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:57926 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbYKEJVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:21:52 -0500
Date: Wed, 5 Nov 2008 10:20:17 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       jeremy@xensource.com
Subject: Re: [PATCH 1/3] block: add queue flag for paravirt frontend drivers
Message-ID: <20081105092016.GD21867@kernel.dk>
References: <1219754894.7235.44.camel@sebastian.kern.oss.ntt.co.jp> <20080826143900.GM20055@kernel.dk> <1219814047.18991.52.camel@sebastian.kern.oss.ntt.co.jp> <1225100686.7370.79.camel@sebastian.kern.oss.ntt.co.jp> <20081027125624.GA22217@kernel.dk> <4910D97E.2030203@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4910D97E.2030203@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04 2008, Jeremy Fitzhardinge wrote:
> Jens Axboe wrote:
> >On Mon, Oct 27 2008, Fernando Luis Vázquez Cao wrote:
> >
> >>As is the case with SSD devices, we do not want to idle in AS/CFQ when
> >>the block device is a paravirt front-end driver. This patch adds a flag
> >>(QUEUE_FLAG_VIRT) which should be used by front-end drivers such as
> >>virtio_blk and xen-blkfront to indicate a paravirtualized device.
> >>
> >
> >All three patches look fine, although we could just reuse
> >QUEUE_FLAG_NONROT directly. But I agree it makes sense to make the
> >distinction, so I've just applied 1-3.
> >
> 
> I guess in theory you could imagine that the virtual device is mapped
> directly onto a physical device, and the host OS does no scheduling, in
> which case it would be appropriate for the guest do the work.  But I
> think otherwise this makes sense.

For that specific case, it should just not set the flag.

-- 
Jens Axboe

