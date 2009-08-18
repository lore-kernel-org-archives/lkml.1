Return-Path: <linux-kernel-owner+w=401wt.eu-S1758311AbZHRAGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758311AbZHRAGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 20:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbZHRAGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 20:06:50 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:40693 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbZHRAGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 20:06:49 -0400
Subject: Re: [patch 2/3] flex_array: fix flex_array_free_parts comment
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0908171645270.30313@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908171644540.30313@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0908171645270.30313@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 17:06:46 -0700
Message-Id: <1250554007.10725.22008.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-17 at 16:46 -0700, David Rientjes wrote:
> flex_array_free_parts() does not take `src' or `element_nr' formals, so
> remove their respective comments.
> 
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  lib/flex_array.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/lib/flex_array.c b/lib/flex_array.c
> --- a/lib/flex_array.c
> +++ b/lib/flex_array.c
> @@ -122,9 +122,6 @@ static int fa_element_to_part_nr(struct flex_array *fa, int element_nr)
> 
>  /**
>   * flex_array_free_parts - just free the second-level pages
> - * @src:	address of data to copy into the array
> - * @element_nr:	index of the position in which to insert
> - * 		the new element.
>   *
>   * This is to be used in cases where the base 'struct flex_array'
>   * has been statically allocated and should not be free.

Looks great to me.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

