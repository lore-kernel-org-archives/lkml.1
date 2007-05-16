Return-Path: <linux-kernel-owner+w=401wt.eu-S1762681AbXEPGno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762681AbXEPGno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 02:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760257AbXEPGnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 02:43:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46153
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760032AbXEPGng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 02:43:36 -0400
Date: Tue, 15 May 2007 23:43:43 -0700 (PDT)
Message-Id: <20070515.234343.74747977.davem@davemloft.net>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, mroos@linux.ee, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: slab hang on boot
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070515.180316.41635662.davem@davemloft.net>
References: <20070515.173820.101498227.davem@davemloft.net>
	<Pine.LNX.4.64.0705151759420.4399@schroedinger.engr.sgi.com>
	<20070515.180316.41635662.davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 15 May 2007 18:03:16 -0700 (PDT)

> From: Christoph Lameter <clameter@sgi.com>
> Date: Tue, 15 May 2007 18:00:23 -0700 (PDT)
> 
> > Slab allocators: Define common size limitations
> 
> Thanks for doing this work Christoph, I'll test this patch out on all
> my sparc64 boxes, with both SLAB and SLUB, later this evening.

SLAB works properly again on sparc64 with this patch, thanks
Christophe.

Signed-off-by: David S. Miller <davem@davemloft.net>
