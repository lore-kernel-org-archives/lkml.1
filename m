Return-Path: <linux-kernel-owner+w=401wt.eu-S1762872AbXERRLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762872AbXERRLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 13:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbXERRLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 13:11:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59428 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757242AbXERRLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 13:11:12 -0400
Date: Fri, 18 May 2007 10:11:33 -0700
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: clameter@sgi.com, mpm@selenic.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, tgraf@suug.ch, davem@davemloft.net,
       akpm@linux-foundation.org, phillips@google.com, penberg@cs.helsinki.fi
Subject: Re: [PATCH 0/5] make slab gfp fair
Message-Id: <20070518101133.800db8de.pj@sgi.com>
In-Reply-To: <1179482054.2925.52.camel@lappy>
References: <20070514131904.440041502@chello.nl>
	<Pine.LNX.4.64.0705161957440.13458@schroedinger.engr.sgi.com>
	<1179385718.27354.17.camel@twins>
	<Pine.LNX.4.64.0705171027390.17245@schroedinger.engr.sgi.com>
	<20070517175327.GX11115@waste.org>
	<Pine.LNX.4.64.0705171101360.18085@schroedinger.engr.sgi.com>
	<1179429499.2925.26.camel@lappy>
	<Pine.LNX.4.64.0705171220120.3043@schroedinger.engr.sgi.com>
	<1179437209.2925.29.camel@lappy>
	<Pine.LNX.4.64.0705171516260.4593@schroedinger.engr.sgi.com>
	<1179482054.2925.52.camel@lappy>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter wrote:
> cpusets are ignored when in dire straights for an kernel alloc.

No - most kernel allocations never ignore cpusets.

The ones marked NOFAIL or ATOMIC can ignore cpusets in dire straights
and the ones off interrupts lack an applicable cpuset context.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
