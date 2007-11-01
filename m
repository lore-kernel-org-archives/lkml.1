Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbXKAWOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbXKAWOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXKAWOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:14:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38647
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752771AbXKAWOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:14:41 -0400
Date: Thu, 01 Nov 2007 15:14:40 -0700 (PDT)
Message-Id: <20071101.151440.88131899.davem@davemloft.net>
To: clameter@sgi.com
Cc: dada1@cosmosbay.com, akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711011511240.22508@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711010555390.27666@schroedinger.engr.sgi.com>
	<20071101.142809.179954273.davem@davemloft.net>
	<Pine.LNX.4.64.0711011511240.22508@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Thu, 1 Nov 2007 15:11:41 -0700 (PDT)

> On Thu, 1 Nov 2007, David Miller wrote:
> 
> > The remaining issue with accessing per-cpu areas at multiple virtual
> > addresses is D-cache aliasing.
> 
> But that is not an issue for physicallly mapped caches.

Right but I'd like to use this on sparc64 which has L1 D-cache
aliasing on some chips :-)
