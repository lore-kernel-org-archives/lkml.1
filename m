Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbXFNVZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbXFNVZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 17:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbXFNVZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 17:25:41 -0400
Received: from ms-smtp-03.texas.rr.com ([24.93.47.42]:54950 "EHLO
	ms-smtp-03.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbXFNVZj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 17:25:39 -0400
From: Dave McCracken <dave.mccracken@oracle.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large Blocksize support
Date: Thu, 14 Jun 2007 16:25:20 -0500
User-Agent: KMail/1.9.7
References: <20070614193839.878721298@sgi.com> <20070614130645.cabdff1b.akpm@linux-foundation.org> <20070614210749.GA23514@infradead.org>
In-Reply-To: <20070614210749.GA23514@infradead.org>
Organization: Oracle Corp
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706141625.21127.dave.mccracken@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007, Christoph Hellwig wrote:
> Christophs patches are an extremly useful cleanup and can stand on their
> own.  Right now PAGE_CACHE_SIZE and friends are in there and now one can
> keep them distinct because their useage is not clear at all.  By making
> the macros per-mapping at least the useage is clear.
>
> That beeing said we should do a full conversion so that PAGE_CACHE_SIZE
> just goes away, otherwise the whole excercise is rather pointless.

I agree with Christoph  and Christoph here.  The page_cache_xxx() macros are 
cleaner than PAGE_CACHE_SIZE.  Too many places have gotten it wrong too many 
times.  Let's go ahead with them even if we never implement variable cache 
page size.

Dave McCracken
