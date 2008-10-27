Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbYJ0Jnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbYJ0Jnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 05:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYJ0Jnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 05:43:47 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:44953 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbYJ0Jnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 05:43:47 -0400
Subject: Re: [PATCH] virtio_blk: use noop elevator by default
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
In-Reply-To: <20080826143900.GM20055@kernel.dk>
References: <1219754894.7235.44.camel@sebastian.kern.oss.ntt.co.jp>
	 <20080826143900.GM20055@kernel.dk>
Content-Type: text/plain; charset=utf-8
Organization: NTT Open Source Software Center
Date: Mon, 27 Oct 2008 18:43:40 +0900
Message-Id: <1225100620.7370.77.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-26 at 16:39 +0200, Jens Axboe wrote:
> On Tue, Aug 26 2008, Fernando Luis Vázquez Cao wrote:
> > Hi Rusty,
> > 
> > Would it make sense to use noop by default? After all we do not know
> > what is behind the backend driver and the hypervisor is likely to do its
> > own scheduling anyway. I guess this is the reason the Xen guys took this
> > approach.
> > 
> > What do you think about the patch below?
> 
> I plan to include some variant of disk profiling for 2.6.28 which will
> let eg CFQ turn off idling for such device types, I think that is a
> better solution.
Thank you for the advice. I will be sending patches that take advantage
of the profiling capability merged for 2.6.28.

