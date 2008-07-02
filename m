Return-Path: <linux-kernel-owner+w=401wt.eu-S1762594AbYGBGpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762594AbYGBGpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 02:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbYGBGp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 02:45:26 -0400
Received: from smtp-out.google.com ([216.239.33.17]:51868 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbYGBGpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 02:45:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=tIpUhQYP3rpaIHiFk/1XZh+O8sDlB7kSYHeQmAWFqP6VMAIu+9Cj8wbIlDyK1zGOi
	xsBLc0q8WZrTV3uuzHgVQ==
Message-ID: <6599ad830807012345r4f02f9acq3c8e9be633e109e8@mail.gmail.com>
Date: Tue, 1 Jul 2008 23:45:15 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH -mmotm] res_counter: fix building failure
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Pavel Emelianov" <xemul@openvz.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>
In-Reply-To: <486B1D3D.5070805@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <486B1D3D.5070805@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2008 at 11:16 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> kernel/res_counter.c: In function 'res_counter_memparse_write_strategy':
> kernel/res_counter.c:115: error: implicit declaration of function 'PAGE_ALIGN'
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Thanks - what architecture did it break on?

Paul

> ---
>
> should follow cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch
>
> --- linux-mm/kernel/res_counter.c.bak   2008-07-02 14:05:37.000000000 +0800
> +++ linux-mm/kernel/res_counter.c       2008-07-02 14:07:36.000000000 +0800
> @@ -13,6 +13,7 @@
>  #include <linux/slab.h>
>  #include <linux/res_counter.h>
>  #include <linux/uaccess.h>
> +#include <linux/mm.h>
>
>  void res_counter_init(struct res_counter *counter)
>  {
>
