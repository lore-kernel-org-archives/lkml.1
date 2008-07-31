Return-Path: <linux-kernel-owner+w=401wt.eu-S1754804AbYGaHU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbYGaHU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 03:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYGaHUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 03:20:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34967 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbYGaHUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 03:20:14 -0400
Date: Thu, 31 Jul 2008 16:19:08 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [patch 2/4] vfs: filp is never NULL in do_generic_file_read()
Cc: kosaki.motohiro@jp.fujitsu.com, viro@ZenIV.linux.org.uk,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080730130914.500576799@szeredi.hu>
References: <20080730130845.905327725@szeredi.hu> <20080730130914.500576799@szeredi.hu>
Message-Id: <20080731161554.3C84.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	*ppos = ((loff_t)index << PAGE_CACHE_SHIFT) + offset;
> -	if (filp)
> -		file_accessed(filp);
> +	file_accessed(filp);
>  }
>  
>  int file_read_actor(read_descriptor_t *desc, struct page *page,

if filp is never NULL, BUG_ON is better?




