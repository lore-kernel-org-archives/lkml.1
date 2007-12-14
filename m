Return-Path: <linux-kernel-owner+w=401wt.eu-S1764793AbXLNJox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764793AbXLNJox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 04:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760954AbXLNJoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 04:44:46 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49674 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758524AbXLNJop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 04:44:45 -0500
Date: Fri, 14 Dec 2007 11:44:42 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <clameter@sgi.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@woody.linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: SLUB: Remove useless masking of GFP_ZERO
In-Reply-To: <Pine.LNX.4.64.0712131246030.18254@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0712141139490.21078@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0712131246030.18254@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007, Christoph Lameter wrote:
> Remove a recently added useless masking of GFP_ZERO. GFP_ZERO is 
> already masked out in new_slab() (See how it calls allocate_slab). No need 
> to do it twice. This reverts the SLUB parts of 
> 7fd272550bd43cc1d7289ef0ab2fa50de137e767.

Oh noes, brown paper bag time for me.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
