Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbYFDG4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbYFDG4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 02:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbYFDG4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 02:56:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57333 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbYFDG4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 02:56:33 -0400
Message-ID: <48463C14.4000705@cn.fujitsu.com>
Date: Wed, 04 Jun 2008 14:54:12 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "menage@google.com" <menage@google.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [RFC][PATCH 1/2] memcg: res_counter hierarchy
References: <20080604135815.498eaf82.kamezawa.hiroyu@jp.fujitsu.com> <20080604140153.fec6cc99.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080604140153.fec6cc99.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Index: temp-2.6.26-rc2-mm1/Documentation/controllers/resource_counter.txt
> ===================================================================
> --- temp-2.6.26-rc2-mm1.orig/Documentation/controllers/resource_counter.txt
> +++ temp-2.6.26-rc2-mm1/Documentation/controllers/resource_counter.txt
> @@ -44,6 +44,13 @@ to work with it.
>   	Protects changes of the above values.
>  
>  
> + f. struct res_counter *parent
> +
> +	Parent res_counter under hierarchy.
> +
> + g. unsigned long long for_children
> +
> +	Resources assigned to children. This is included in usage.

Since parent and for_children are also protected by res_count->lock,
the above text should appear before 'e. spinlock_t lock'.
