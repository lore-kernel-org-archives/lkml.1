Return-Path: <linux-kernel-owner+w=401wt.eu-S965916AbXCPU4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965916AbXCPU4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965925AbXCPU4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:56:16 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50768 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965916AbXCPU4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:56:15 -0400
Date: Fri, 16 Mar 2007 13:56:13 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: mbligh@mbligh.org, andi@firstfloor.org, rostedt@goodmis.org,
       torvalds@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       chrisw@sous-sol.org, rusty@rustcorp.com.au, glommer@gmail.com,
       apw@shadowen.org
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <20070316.135316.115910811.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0703161354520.6204@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0703161313240.6204@schroedinger.engr.sgi.com>
 <45FAFD57.90601@mbligh.org> <Pine.LNX.4.64.0703161346060.6204@schroedinger.engr.sgi.com>
 <20070316.135316.115910811.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007, David Miller wrote:

> From: Christoph Lameter <clameter@sgi.com>
> Date: Fri, 16 Mar 2007 13:48:58 -0700 (PDT)
> 
> > Please read my posts to linux-mm on that subject. We discussed it last 
> > year in detail and the agreement was that the sparsemem crud needs to be 
> > taken out. Kame-san posted patches to do that.
> 
> Please don't do that, sparsemem works very well on sparc64 and I
> like the flexibility it gives me.

I am not sure what flexibility you are talking about? The modification are 
to make sparsemem support virtual memmap as one option. See Kame-san's 
posts. There is no regression here its just cutting out the overhead of 
sparsmem from within.

