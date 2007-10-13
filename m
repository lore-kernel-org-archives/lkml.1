Return-Path: <linux-kernel-owner+w=401wt.eu-S1757219AbXJMMWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219AbXJMMWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 08:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbXJMMWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 08:22:09 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22938 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbXJMMWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 08:22:08 -0400
Date: Sat, 13 Oct 2007 14:22:02 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Build error in block/compat_ioctl.c latest git
Message-ID: <20071013122202.GG969@kernel.dk>
References: <20071013020840.1cf1261a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071013020840.1cf1261a@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13 2007, Alejandro Riveira Fernández wrote:
> 
>   Latest commit is
>   ab9c232286c2b77be78441c2d8396500b045777e
> 
>  /home/alex/kernel/linux-2.6/block/compat_ioctl.c: En la función ???compat_put_ushort???:

This should already be fixed, Linus fixed it up. block/compat_ioctl.o
should only be built when CONFIG_BLOCK && CONFIG_COMPAT are both set.

-- 
Jens Axboe

