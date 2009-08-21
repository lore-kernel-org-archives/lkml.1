Return-Path: <linux-kernel-owner+w=401wt.eu-S932924AbZHUXt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbZHUXt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 19:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932587AbZHUXt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 19:49:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32839 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932374AbZHUXtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 19:49:55 -0400
Date: Fri, 21 Aug 2009 16:49:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: dave@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch 4/4 -mm] flex_array: add flex_array_shrink function
Message-Id: <20090821164935.173689a0.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0908211621160.28611@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0908211619270.28611@chino.kir.corp.google.com>
	<alpine.DEB.2.00.0908211621160.28611@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009 16:21:49 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> +/**
> + * flex_array_shrink - free unused second-level pages
> + *
> + * Frees all second-level pages that consist solely of unused
> + * elements.  Returns the number of pages freed.
> + *
> + * Locking must be provided by the caller.
> + */
> +int flex_array_shrink(struct flex_array *fa)

It's logical but afaik unconventional that none of the flex_array
kerneldoc actually documents the `struct flex_array *fa' argument.


We're all waiting with bated breath to see who will be the first to use
flex_array in live code.

Sometime we'll need to move flex_array.o from lib-y to obj-y and fill
it up with EXPORT_SYMBOL()s.  2.6.32 I expect.

