Return-Path: <linux-kernel-owner+w=401wt.eu-S1758804AbXFDQdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbXFDQdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:33:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756445AbXFDQcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:32:52 -0400
Received: from gw.goop.org ([64.81.55.164]:46218 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756372AbXFDQcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:32:51 -0400
Message-ID: <46643EAB.7070705@goop.org>
Date: Mon, 04 Jun 2007 09:32:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>  <20070601204141.f84ad72f.akpm@linux-foundation.org>  <Pine.LNX.4.64.0706012057580.11358@schroedinger.engr.sgi.com>  <20070601213117.1178e8e0.akpm@linux-foundation.org>  <Pine.LNX.4.64.0706012139480.11577@schroedinger.engr.sgi.com>  <84144f020706040808t4882f961t80b8d8eb145bfa50@mail.gmail.com>  <Pine.LNX.4.64.0706040916090.23191@schroedinger.engr.sgi.com> <84144f020706040922v56cb10eg5a730b4abe9d5251@mail.gmail.com> <alpine.LFD.0.98.0706040924070.23741@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706040924070.23741@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> The thing is, why *should* we care about comparing addresses? We'll give 
> the right result (you got many perfectly separate allocations, they're 
> just zero bytes apart, exactly like you asked for!). The fact that C++ has 
> some semantics for it is not a good argument - C++ is a broken language, 
> and it's not the language we use for the kernel anyway.

C too, but I really honestly can't think of a scenario - realistic or
contrived - in which you'd end up doing a zero-sized allocation and care
that its address has been aliased.  But we'll find out when we do it ;)

    J
