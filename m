Return-Path: <linux-kernel-owner+w=401wt.eu-S1756597AbZKSA0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbZKSA0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 19:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbZKSA0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 19:26:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001AbZKSA0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 19:26:35 -0500
Message-ID: <4B049090.1070300@redhat.com>
Date: Wed, 18 Nov 2009 19:25:52 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>, Izik Eidus <ieidus@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 1/6] mm: define PAGE_MAPPING_FLAGS
References: <Pine.LNX.4.64.0911102142570.2272@sister.anvils> <Pine.LNX.4.64.0911102150350.2816@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0911102150350.2816@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 04:51 PM, Hugh Dickins wrote:
> At present we define PageAnon(page) by the low PAGE_MAPPING_ANON bit
> set in page->mapping, with the higher bits a pointer to the anon_vma;
> and have defined PageKsm(page) as that with NULL anon_vma.
>
> But KSM swapping will need to store a pointer there: so in preparation
> for that, now define PAGE_MAPPING_FLAGS as the low two bits, including
> PAGE_MAPPING_KSM (always set along with PAGE_MAPPING_ANON, until some
> other use for the bit emerges).
>
> Declare page_rmapping(page) to return the pointer part of page->mapping,
> and page_anon_vma(page) to return the anon_vma pointer when that's what
> it is.  Use these in a few appropriate places: notably, unuse_vma() has
> been testing page->mapping, but is better to be testing page_anon_vma()
> (cases may be added in which flag bits are set without any pointer).
>
> Signed-off-by: Hugh Dickins<hugh.dickins@tiscali.co.uk>
>
>    
Reviewed-by: Rik van Riel <riel@redhat.com>

