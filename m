Return-Path: <linux-kernel-owner+w=401wt.eu-S1753608AbYKNC4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbYKNC4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 21:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYKNC4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 21:56:10 -0500
Received: from gw.goop.org ([64.81.55.164]:49435 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbYKNC4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 21:56:09 -0500
Message-ID: <491CE8C6.4060000@goop.org>
Date: Thu, 13 Nov 2008 18:56:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH 1/2] mm: implement remap_pfn_range with apply_to_page_range
References: <491C61B1.10005@goop.org> <200811141319.56713.nickpiggin@yahoo.com.au>
In-Reply-To: <200811141319.56713.nickpiggin@yahoo.com.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
>
> This isn't performance critical to anyone?
>   

The only difference should be between having the specialized code and an 
indirect function call, no?

> I see DRM, IB, GRU, other media and video drivers use it.
>
> It IS exactly what apply_to_page_range does, I grant you. But so does
> our traditional set of nested loops. So is there any particular reason
> to change it? You're not planning to change fork/exit next, are you? :)
>   

No ;)  But I need to have a more Xen-specific version of 
remap_pfn_range, and I wanted to 1) have the two versions look as 
similar as possible, and 2) not have a pile of duplicate code.

    J
