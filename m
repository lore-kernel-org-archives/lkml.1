Return-Path: <linux-kernel-owner+w=401wt.eu-S1761754AbXFSSgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761754AbXFSSgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 14:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761368AbXFSSfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 14:35:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55368 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756545AbXFSSfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 14:35:53 -0400
Date: Tue, 19 Jun 2007 11:35:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cedric Le Goater <clg@fr.ibm.com>, Christoph Lameter <clameter@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Herbert Poetzl <herbert@13thfloor.at>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [PATCH -mm] add a kmem_cache for nsproxy objects
Message-Id: <20070619113501.a88bba50.akpm@linux-foundation.org>
In-Reply-To: <4676F0B9.3080408@fr.ibm.com>
References: <4676F0B9.3080408@fr.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2007 22:53:13 +0200
Cedric Le Goater <clg@fr.ibm.com> wrote:

> +static int __init nsproxy_cache_init(void)
> +{
> +	nsproxy_cachep = kmem_cache_create("nsproxy", sizeof(struct nsproxy),
> +					   0, SLAB_PANIC, NULL, NULL);
> +	return 0;
> +}
> +

Christoph added this cheesy KMEM_CACHE macro.  But I don't immediately recall
the rationale so I'm a bit reluctant to ask people to use-the-cheesy-macro.

Perhaps he can remind us why it is there?
