Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbXFCQRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbXFCQRk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 12:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbXFCQRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 12:17:33 -0400
Received: from waste.org ([66.93.16.53]:50781 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbXFCQRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 12:17:32 -0400
Date: Sun, 3 Jun 2007 11:17:22 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, jeremy@goop.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
Message-ID: <20070603161722.GP11166@waste.org>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com> <20070601204141.f84ad72f.akpm@linux-foundation.org> <Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com> <20070601213117.1178e8e0.akpm@linux-foundation.org> <Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com> <20070601215427.f06d09e7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601215427.f06d09e7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 09:54:27PM -0700, Andrew Morton wrote:
> We lose leak-detection and double-free detection this way, too.  Not a big
> deal.

We could keep a global counter and warn if count < 0 or > N.

An awful lot of fuss over nothing though.

-- 
Mathematics is the supreme nostalgia of our time.
