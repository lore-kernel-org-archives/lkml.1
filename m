Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbZFKOAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbZFKOAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbZFKOAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:00:24 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50143 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbZFKOAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:00:23 -0400
Subject: Re: [PATCH 2/2] SLUB: Disable debugging if it increases the
 minimum page order
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mel@csn.ul.ie, Larry.Finger@lwfinger.net
In-Reply-To: <alpine.DEB.1.10.0906110941520.29827@gentwo.org>
References: <Pine.LNX.4.64.0906111143490.6132@melkki.cs.Helsinki.FI>
	 <alpine.DEB.1.10.0906110941520.29827@gentwo.org>
Date: Thu, 11 Jun 2009 17:00:24 +0300
Message-Id: <1244728824.17483.51.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Thu, 2009-06-11 at 09:43 -0400, Christoph Lameter wrote:
> We have had that with SLAB. NO! This leads to the situation that some
> slabs have debug on and some have not. You just do not know which.

I do see your point but surely we don't want to use order 1 allocations
in the fall-back case for kmalloc-4096? Couldn't we just add a printk
saying that debug was disabled for the cache? After all, my patch is
much better than what SLAB does.

On Thu, 2009-06-11 at 09:43 -0400, Christoph Lameter wrote:
> Note that CONFIG_SLUB_DEBUG only enables the code to debug a slab. It does
> not enable debugging for each slab. CONFIG_SLUB_DEBUG_ON does that.

True. Larry, do you have CONFIG_SLUB_DEBUG_ON enabled or are you passing
SLUB debugging options to the kernel?

			Pekka

