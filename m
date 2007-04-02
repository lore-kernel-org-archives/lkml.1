Return-Path: <linux-kernel-owner+w=401wt.eu-S933928AbXDBGn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928AbXDBGn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 02:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933935AbXDBGn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 02:43:59 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:14000 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933928AbXDBGn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 02:43:59 -0400
Date: Mon, 2 Apr 2007 08:42:45 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
Message-ID: <20070402064245.GC11996@kernel.dk>
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk> <460EA727.8070306@gmail.com> <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com> <4610481D.8000102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4610481D.8000102@gmail.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02 2007, Rene Herman wrote:
> On 04/01/2007 12:06 PM, Pekka Enberg wrote:
> 
> >Looks like mcdx_xfer is sleeping while holding q->queue_lock. The 
> >attached (untested) patch should fix it.
> 
> This (including your followup) does indeed avoid the traces in the 
> kernel log, but unfortunately, the driver seems to need a bit more.

I took a quick look at the driver, and it's pretty much utter crap so I
would not expect much. If you want to use it, make sure you at least
disable any form of SMP and preempt.

> Last time Al Viro suggested ripping them out, I slightly objected:
> 
> http://lkml.org/lkml/2004/5/2/123
> 
> but well, although I like playing with this stuff, I still don't know 
> the first thing about the block layer and given the shape these things 
> are in...

The questionable quality of the ancient CDROM drivers itself makes it
appealing to just dump it.

-- 
Jens Axboe

