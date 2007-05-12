Return-Path: <linux-kernel-owner+w=401wt.eu-S1761284AbXELBeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761284AbXELBeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 21:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756611AbXELBd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 21:33:56 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:33733 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756325AbXELBd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 21:33:56 -0400
Date: Sat, 12 May 2007 10:33:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [patch 2/2] Slab allocators: Drop support for destructors
Message-ID: <20070512013325.GB27172@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>, clameter@sgi.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	Pekka Enberg <penberg@cs.helsinki.fi>
References: <20070511165749.026947116@sgi.com> <20070511165946.145806097@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511165946.145806097@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 09:57:51AM -0700, clameter@sgi.com wrote:
> There is no user of destructors left. There is no reason why we should
> keep checking for destructors calls in the slab allocators.
> 
> The RFC for this patch was discussed at
> http://marc.info/?l=linux-kernel&m=117882364330705&w=2
> 
> Destructors were mainly used for list management which required them to take a
> spinlock. Taking a spinlock in a destructor is a bit risky since the slab
> allocators may run the destructors anytime they decide a slab is no longer
> needed.
> 
> Patch drops destructor support. Any attempt to use a destructor will BUG().
> 
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
Acked-by: Paul Mundt <lethal@linux-sh.org>
