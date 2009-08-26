Return-Path: <linux-kernel-owner+w=401wt.eu-S1751635AbZHZQLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbZHZQLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbZHZQLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:11:07 -0400
Received: from smtp4.ultrahosting.com ([74.213.175.253]:54670 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751050AbZHZQLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:11:06 -0400
Date: Wed, 26 Aug 2009 12:10:24 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Nitin Gupta <ngupta@vflare.org>
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-mm-cc@laptop.org
Subject: Re: [PATCH 1/4] compcache: xvmalloc memory allocator
In-Reply-To: <4A94358C.6060708@vflare.org>
Message-ID: <alpine.DEB.1.10.0908261209240.9933@gentwo.org>
References: <200908241007.47910.ngupta@vflare.org> <84144f020908241033l4af09e7h9caac47d8d9b7841@mail.gmail.com> <4A92EBB4.1070101@vflare.org> <Pine.LNX.4.64.0908242132320.8144@sister.anvils> <4A930313.9070404@vflare.org> <Pine.LNX.4.64.0908242224530.10534@sister.anvils>
 <4A93FAA5.5000001@vflare.org> <4A94358C.6060708@vflare.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Nitin Gupta wrote:

> I went crazy. I meant 40 bits for PFN -- not 48. This 40-bit PFN should be
> sufficient for all archs. For archs where 40 + PAGE_SHIFT < MAX_PHYSMEM_BITS
> ramzswap will just issue a compiler error.

How about restricting the xvmalloc memory allocator to 32 bit? If I
understand correctly xvmalloc main use in on 32 bit in order to be
able to use HIGHMEM?

