Return-Path: <linux-kernel-owner+w=401wt.eu-S1761078AbYBHVmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761078AbYBHVmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbYBHVl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:41:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45249 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759894AbYBHVlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:41:55 -0500
Date: Fri, 8 Feb 2008 13:41:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/1] mxser: convert large macros to functions
Message-Id: <20080208134115.9289b7c7.akpm@linux-foundation.org>
In-Reply-To: <1202462208-6171-1-git-send-email-jirislaby@gmail.com>
References: <1202462208-6171-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Feb 2008 10:16:48 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> From: Christoph Hellwig <hch@lst.de>
> 
> From: Christoph Hellwig <hch@lst.de>
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Jiri Slaby <jirislaby@gmail.com>

This should have been Signed-off-by: - you were in the delivery path.

I'll make that change.

> --- a/drivers/char/mxser.c
> +++ b/drivers/char/mxser.c

Has this been runtime tested?

> -	DISABLE_MOXA_MUST_ENCHANCE_MODE(io);
> +	mxser_disable_must_enchance_mode(io);

hm, what's all this "enchance" stuff throughout the driver?  Did it mean
"enhance"?


