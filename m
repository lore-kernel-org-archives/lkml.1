Return-Path: <linux-kernel-owner+w=401wt.eu-S1759932AbXEPAdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932AbXEPAdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 20:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760653AbXEPAcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 20:32:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46021 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759656AbXEPAcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 20:32:50 -0400
Date: Tue, 15 May 2007 17:29:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: clameter@sgi.com, mroos@linux.ee, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: slab hang on boot
Message-Id: <20070515172957.02d80d51.akpm@linux-foundation.org>
In-Reply-To: <20070515.171447.83623268.davem@davemloft.net>
References: <20070515163321.744e2388.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705151642530.3886@schroedinger.engr.sgi.com>
	<20070515165636.5057456e.akpm@linux-foundation.org>
	<20070515.171447.83623268.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 17:14:47 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Tue, 15 May 2007 16:56:36 -0700
> 
> > On Tue, 15 May 2007 16:45:22 -0700 (PDT)
> > Christoph Lameter <clameter@sgi.com> wrote:
> > 
> > > KMALLOC_SHIFT_HIGH is not a constant but may be less than 25.
> > 
> > It darn well better be a compile-time constant.
> 
> Try to define a compile-time array size with it smarty
> pants :-)

confusedy pants, more like.

> That's what we did initially and it doesn't work.

This:

struct kmem_cache kmalloc_caches[KMALLOC_SHIFT_HIGH + 1] __cacheline_aligned;

is still there.


