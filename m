Return-Path: <linux-kernel-owner+w=401wt.eu-S1761467AbXJYXJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761467AbXJYXJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755544AbXJYXJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:09:12 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:40563 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400AbXJYXJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:09:09 -0400
Message-ID: <47212215.8080003@oracle.com>
Date: Thu, 25 Oct 2007 16:09:09 -0700
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/31] Add an ERR_CAST() macro to complement ERR_PTR and
 co.	[try #5]
References: <20071025163352.5057.59344.stgit@warthog.procyon.org.uk> <20071025163357.5057.35399.stgit@warthog.procyon.org.uk>
In-Reply-To: <20071025163357.5057.35399.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> + * ERR_CAST - Explicitly cast an error-valued pointer to another pointer type
> + * @ptr: The pointer to cast.
> + *
> + * Explicitly cast an error-valued pointer to another pointer type in such a
> + * way as to make it clear that's what's going on.
> + */
> +static inline void *ERR_CAST(const void *ptr)
> +{
> +	return (void *) ptr;
> +}

Just to nit, surely you don't need the cast inside the function.  The
casting happens at the call site between the argument and returned pointer.

- z
