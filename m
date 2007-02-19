Return-Path: <linux-kernel-owner+w=401wt.eu-S932128AbXBSLrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbXBSLrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932145AbXBSLrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:47:40 -0500
Received: from mail.screens.ru ([213.234.233.54]:44062 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932128AbXBSLrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:47:39 -0500
Date: Mon, 19 Feb 2007 14:47:36 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] drivers/media/video/cpia_pp.c: don't use _WORK_NAR
Message-ID: <20070219114736.GA91@tv-sign.ru>
References: <20070218214415.GA4232@tv-sign.ru> <8637.1171885038@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8637.1171885038@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19, David Howells wrote:
>
> Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > pp_cam_entry->cb_task need not to be _NOAUTOREL ... because in fact it is
> > never used ???
> 
> That's a remarkably good point.  Did something get deleted since I made my
> modifications?

At first I thought the same. But no, it looks unused as well in 2.6.18.

>                  Perhaps the workqueue stuff in that file should just be
> deleted entirely.

I think yes.

> Acked-By: David Howells <dhowells@redhat.com>

Thanks.

Oleg.

