Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbZF3U0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbZF3U0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 16:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbZF3U0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 16:26:06 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60468 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbZF3U0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 16:26:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <E1MLa4R-00054S-94@pomaz-ex.szeredi.hu>
References: <E1MLa4R-00054S-94@pomaz-ex.szeredi.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, hch@infradead.org, drepper@gmail.com,
       torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [RFC PATCH] vfs: new open(2) flag to open filesystem node
Date: Tue, 30 Jun 2009 21:25:35 +0100
Message-ID: <2547.1246393535@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> @@ -1790,7 +1801,8 @@ do_last:
>  		if (!(flag & O_NOFOLLOW))
>  			goto do_link;
>  		error = -ELOOP;
> -		goto exit_dput;
> +		if (!(flag & O_NODE))
> +			goto exit_dput;
>  	}
>  
>  	path_to_nameidata(&path, &nd);

This hunk doesn't apply.

David
