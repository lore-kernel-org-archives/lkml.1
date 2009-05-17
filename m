Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbZEQUP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbZEQUP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 16:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbZEQUPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 16:15:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49616 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbZEQUPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 16:15:14 -0400
Message-ID: <4A10704E.1080301@redhat.com>
Date: Sun, 17 May 2009 23:15:10 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v2 4/4] kvm: add iosignalfd support
References: <20090515162047.26209.93545.stgit@dev.haskins.net> <20090515162823.26209.72294.stgit@dev.haskins.net>
In-Reply-To: <20090515162823.26209.72294.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> +
> +struct _iosignalfd {
>   

Why the underscore?  It's unorthodox for a structure.

> +	u64                  cookie;
> +	u64                  addr;
> +	size_t               length;
> +	struct file         *file;
> +	struct list_head     list;
> +	struct kvm_io_device dev;
> +};
>   

How will that work with multiple identical addresses and different 
cookies?  Will the code iterate over all of them and just fire for one?

I guess that's the best way for now.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

