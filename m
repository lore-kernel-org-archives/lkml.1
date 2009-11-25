Return-Path: <linux-kernel-owner+w=401wt.eu-S933527AbZKYA0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527AbZKYA0N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 19:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933299AbZKYA0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 19:26:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932942AbZKYA0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 19:26:12 -0500
Date: Tue, 24 Nov 2009 16:25:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, isdn@linux-pingi.de, mac@melware.de
Subject: Re: [PATCH] proc_fops: convert drivers/isdn/ to seq_file
Message-Id: <20091124162541.03e7e375.akpm@linux-foundation.org>
In-Reply-To: <20091123015625.GA32088@x200.localdomain>
References: <20091123015625.GA32088@x200.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Nov 2009 04:56:25 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  Documentation/isdn/INTERFACE.CAPI       |    4 
>  drivers/isdn/capi/capi.c                |   99 +++++-----------
>  drivers/isdn/capi/capidrv.c             |   54 ++------
>  drivers/isdn/capi/kcapi.c               |    8 -
>  drivers/isdn/hardware/avm/avmcard.h     |    6 
>  drivers/isdn/hardware/avm/b1.c          |   54 +++++---
>  drivers/isdn/hardware/avm/b1dma.c       |   71 +++++------
>  drivers/isdn/hardware/avm/b1isa.c       |    2 
>  drivers/isdn/hardware/avm/b1pci.c       |    4 
>  drivers/isdn/hardware/avm/b1pcmcia.c    |    2 
>  drivers/isdn/hardware/avm/c4.c          |   53 +++++---
>  drivers/isdn/hardware/avm/t1isa.c       |    2 
>  drivers/isdn/hardware/avm/t1pci.c       |    2 
>  drivers/isdn/hardware/eicon/capimain.c  |   40 +++---
>  drivers/isdn/hardware/eicon/diva_didd.c |   44 +++----
>  drivers/isdn/hardware/eicon/divasi.c    |   48 ++++---
>  drivers/isdn/hardware/eicon/divasproc.c |  198 ++++++++++++++------------------
>  drivers/isdn/hysdn/hycapi.c             |   54 ++++----
>  include/linux/isdn/capilli.h            |    3 
>  net/bluetooth/cmtp/capi.c               |   37 +++--
>  20 files changed, 368 insertions(+), 417 deletions(-)

linux-next collision:

drivers/isdn/gigaset/capi.c: In function 'gigaset_isdn_register':
drivers/isdn/gigaset/capi.c:2259: error: 'struct capi_ctr' has no member named 'ctr_read_proc'
