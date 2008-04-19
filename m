Return-Path: <linux-kernel-owner+w=401wt.eu-S1760822AbYDSOnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822AbYDSOnz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 10:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbYDSOnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 10:43:45 -0400
Received: from ozlabs.org ([203.10.76.45]:50394 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbYDSOno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 10:43:44 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/5] tun: vringfd xmit support.
Date: Sun, 20 Apr 2008 00:41:43 +1000
User-Agent: KMail/1.9.9
Cc: netdev@vger.kernel.org, Max Krasnyansky <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <200804181433.48488.rusty@rustcorp.com.au> <200804190115.15983.rusty@rustcorp.com.au> <20080418120634.986e30f1.akpm@linux-foundation.org>
In-Reply-To: <20080418120634.986e30f1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804200041.43969.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 April 2008 05:06:34 Andrew Morton wrote:
> On Sat, 19 Apr 2008 01:15:15 +1000 Rusty Russell <rusty@rustcorp.com.au> 
wrote:
> > > What is the maximum numbet of pages which an unpriviliged user can
> > > concurrently pin with this code?
> >
> > Since only root can open the tun device, it's currently OK.  The old code
> > kmalloced and copied: is there some mm-fu reason why pinning userspace
> > memory is worse?
>
> We generally try to avoid it - it allows users to dos the box.

My question is: is pinning a page worse than allocating a (kernel) page in 
some way?

Cheers,
Rusty.
