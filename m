Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbXE3Vqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbXE3Vqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758077AbXE3Vpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:45:41 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759270AbXE3Vpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:45:40 -0400
Date: Wed, 30 May 2007 14:45:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelianov <xemul@openvz.org>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 2/8] Add container pointer on struct page
Message-Id: <20070530144502.991ffbac.akpm@linux-foundation.org>
In-Reply-To: <465D9804.9040904@openvz.org>
References: <465D9739.8070209@openvz.org>
	<465D9804.9040904@openvz.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 19:28:04 +0400
Pavel Emelianov <xemul@openvz.org> wrote:

> +#ifdef CONFIG_RSS_CONTAINER
> +#define page_container(page)	(page->rss_container)
> +#else
> +#define page_container(page)	(NULL)
> +#endif

static inline C functions are nicer.
