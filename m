Return-Path: <linux-kernel-owner+w=401wt.eu-S1757605AbXFSUzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbXFSUzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbXFSUzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:55:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:44311 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbXFSUzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:55:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kGbTP9tTLi35AA//db3+Ye4AyNAJ4gjZDfXaZb/lYfRbDL23DIN2Y5JHY+Aa3JWjkDhaR8pIAD+I8Ivc2pEEcV9UOn9LWb1/vaY+R4Fn+dsaDW524k09fpjKs11MffxxUzmPO4/q70j+yzWJzcw3ffzQxU4HJYgwF9QsY9CHD0M=
Message-ID: <84144f020706191355m10435927o153e91f16af1c8dd@mail.gmail.com>
Date: Tue, 19 Jun 2007 23:55:00 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "clameter@sgi.com" <clameter@sgi.com>
Subject: Re: [patch 06/26] Slab allocators: Replace explicit zeroing with __GFP_ZERO
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, suresh.b.siddha@intel.com
In-Reply-To: <20070618095914.862238426@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070618095838.238615343@sgi.com>
	 <20070618095914.862238426@sgi.com>
X-Google-Sender-Auth: 5f6d776c9b8a51da
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/18/07, clameter@sgi.com <clameter@sgi.com> wrote:
> kmalloc_node() and kmem_cache_alloc_node() were not available in
> a zeroing variant in the past. But with __GFP_ZERO it is possible
> now to do zeroing while allocating.

Looks good. Maybe we want to phase out the zeroing variants altogether
(expect maybe kzalloc which is wide-spread now)?

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
