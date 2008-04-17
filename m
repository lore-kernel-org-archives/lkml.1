Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbYDQEGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbYDQEGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 00:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbYDQEGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 00:06:10 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:18039 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYDQEGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 00:06:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Z4fVgBY3jeigLshtjEyUnclSu9cOMpGJKuNOmQMpkYF4TJK74bGD0AwCpPwfrqMltads7OSA4QArTJjkffhK3e9UC3fJmF6xNTVRwPuipWz3qyjWHH7ckZA99b5vNOJCz45hdnyclGwhr4vqjDuhsiANwweqS7tVcRnm+NNbcik=
Subject: Re: [PATCH -mm] relayfs: support larger relay buffer take 3
From: Tom Zanussi <tzanussi@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, David Wilder <dwilder@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <480658DC.6030507@redhat.com>
References: <4804C95F.2080204@redhat.com>
	 <1208319769.7893.16.camel@charm-linux> <48063F80.9060404@redhat.com>
	 <Pine.LNX.4.64.0804162110070.19171@sbz-30.cs.Helsinki.FI>
	 <480646B2.9000905@redhat.com>  <480658DC.6030507@redhat.com>
Content-Type: text/plain
Date: Wed, 16 Apr 2008 23:05:28 -0500
Message-Id: <1208405128.8701.42.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-16 at 15:51 -0400, Masami Hiramatsu wrote:
> Use vmalloc() and memset() instead of kcalloc() to allocate a page* array
> when the array size is bigger than one page. This enables relayfs to support
> bigger relay buffers than 64MB on 4k-page system, 512MB on 16k-page system.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> ---
> Changes from take2 to take3:
>  - Use struct page ** instead of struct page *.
>  - move functions to the place before relay_mmap_buf.
>  - add comments.
> 
> This is useful for a 64-bit system which has a plenty of memory (tens of
> giga bytes) and a large kernel memory space.
> 
> I tested it on x86-64 and ia64.
> 

Hi,

Looks fine to me.

Reviewed-by: Tom Zanussi <tzanussi@gmail.com>



