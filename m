Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbZHXVnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbZHXVnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbZHXVnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:43:08 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:42440 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbZHXVnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:43:07 -0400
Date: Mon, 24 Aug 2009 12:42:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] doc/rbtree: fix inserting example
Message-Id: <20090824124239.f7525b97.randy.dunlap@oracle.com>
In-Reply-To: <4A918BAF.8020600@gmail.com>
References: <4A918BAF.8020600@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt002.oracle.com [141.146.116.11]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4A93091E.003B:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Aug 2009 20:34:23 +0200 Marcin Slusarz wrote:

> rb_link_node and rb_insert_color take pointer to struct rb_node
> as a first parameter, but example code passes plain struct rb_node.
> Fix it.

This is already corrected in the mainline kernel tree, right?


> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  Documentation/rbtree.txt |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/rbtree.txt b/Documentation/rbtree.txt
> index 7224459..b67a87e 100644
> --- a/Documentation/rbtree.txt
> +++ b/Documentation/rbtree.txt
> @@ -131,8 +131,8 @@ Example:
>    	}
>  
>    	/* Add new node and rebalance tree. */
> -  	rb_link_node(data->node, parent, new);
> -  	rb_insert_color(data->node, root);
> +  	rb_link_node(&data->node, parent, new);
> +  	rb_insert_color(&data->node, root);
>  
>  	return TRUE;
>    }


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
