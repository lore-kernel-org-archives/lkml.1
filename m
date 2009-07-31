Return-Path: <linux-kernel-owner+w=401wt.eu-S1751621AbZGaFgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbZGaFgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 01:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbZGaFgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 01:36:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37557 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbZGaFgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 01:36:22 -0400
From: Nikanth Karthikesan <knikanth@novell.com>
Organization: Novell
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] io context: fix ref counting
Date: Fri, 31 Jul 2009 11:08:06 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.31-rc4-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
References: <4A7280F8.1070401@cn.fujitsu.com>
In-Reply-To: <4A7280F8.1070401@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907311108.06424.knikanth@novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 July 2009 10:58:24 Li Zefan wrote:
> Commit d9c7d394a8ebacb60097b192939ae9f15235225e
> ("block: prevent possible io_context->refcount overflow") mistakenly
> changed atomic_inc(&ioc->nr_tasks) to atomic_long_inc(&ioc->refcount).
>

Ah! Sorry. :(

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Nikanth Karthikesan <knikanth@suse.de>

Thanks
Nikanth
