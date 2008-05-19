Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbYESJFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbYESJFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 05:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbYESJFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 05:05:20 -0400
Received: from ozlabs.org ([203.10.76.45]:42257 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349AbYESJFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 05:05:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 2/2] lguest: virtio-rng support
Date: Mon, 19 May 2008 19:05:10 +1000
User-Agent: KMail/1.9.9
Cc: "H. Peter Anvin" <hpa@zytor.com>, Theodore Tso <tytso@mit.edu>,
       Herbert Xu <herbert@gondor.apana.org.au>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Matt Mackall <mpm@selenic.com>,
       Johannes Berg <johannes@sipsolutions.net>
References: <482C8595.5030509@garzik.org> <200805171628.03801.rusty@rustcorp.com.au> <482E8D75.10606@goop.org>
In-Reply-To: <482E8D75.10606@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805191905.11452.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 May 2008 17:47:01 Jeremy Fitzhardinge wrote:
> But the host->guest protocol should include the number of bits estimated
> entropy along with the bits themselves.

If we go down that path, we have to come up with a way of feeding that 
information to guest userspace.  Patches welcome.  If we meanwhile assume 
entropy == #bits, it fits the current /dev/hwrng model, and we can add an 
entropy count later if we want to change that.

I'll change my lguest implementation to suck from /dev/random, since noone 
else seems to consider its depletion to be a real issue.  It's no worse than 
what any other process can do.

Thanks,
Rusty.
