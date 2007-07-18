Return-Path: <linux-kernel-owner+w=401wt.eu-S1765584AbXGRGtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765584AbXGRGtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 02:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbXGRGt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 02:49:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:35516 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbXGRGt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 02:49:27 -0400
Subject: Re: [PATCH] vmalloc_32 should use GFP_KERNEL
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Dave Airlie <airlied@gmail.com>, Andi Kleen <ak@suse.de>
In-Reply-To: <20070717233358.2edeaac0.akpm@linux-foundation.org>
References: <1184739934.25235.220.camel@localhost.localdomain>
	 <20070717233358.2edeaac0.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 18 Jul 2007 16:49:14 +1000
Message-Id: <1184741354.25235.222.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-17 at 23:33 -0700, Andrew Morton wrote:
> whoops, yes.
> 
> Are those errors serious and common enough for 2.6.22.x?  

No idea, so far, the nouveau DRM isn't something I would recommend to
people to use in stable environments but heh... I don't know who else
uses vmalloc_32.

Cheers,
Ben.

