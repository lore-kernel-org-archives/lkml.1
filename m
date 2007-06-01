Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbXFAVrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbXFAVrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 17:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763601AbXFAVrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 17:47:45 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56092 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761412AbXFAVro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 17:47:44 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <466093F1.8040204@s5r6.in-berlin.de>
Date: Fri, 01 Jun 2007 23:47:29 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070408 SeaMonkey/1.1.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH] lib: add idr_for_each()
References: <11807281632412-git-send-email-krh@redhat.com>
In-Reply-To: <11807281632412-git-send-email-krh@redhat.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
>  /**
> + * idr_for_each - iterate through all stored pointers
...
> + * The caller must serialize idr_find() vs idr_get_new() and idr_remove().
                                ^^^^^^^^
> + */
> +int idr_for_each(struct idr *idp,
> +		 int (*fn)(int id, void *p, void *data), void *data)
> +{

...must serialize idr_for_each() vs...

-- 
Stefan Richter
-=====-=-=== -==- ----=
http://arcgraph.de/sr/
