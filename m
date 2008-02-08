Return-Path: <linux-kernel-owner+w=401wt.eu-S1760999AbYBHVgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760999AbYBHVgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbYBHVgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:36:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59838 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756134AbYBHVgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:36:02 -0500
Date: Fri, 8 Feb 2008 13:35:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       jirislaby@gmail.com
Subject: Re: [PATCH 1/1] tty: BKL pushdown fix
Message-Id: <20080208133530.0e453c50.akpm@linux-foundation.org>
In-Reply-To: <1202497487-32550-1-git-send-email-jirislaby@gmail.com>
References: <20080208154208.0efd6885@core>
	<1202497487-32550-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Feb 2008 20:04:47 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> --- a/drivers/char/n_hdlc.c
> +++ b/drivers/char/n_hdlc.c
> @@ -579,7 +579,7 @@ static ssize_t n_hdlc_tty_read(struct tty_struct *tty, struct file *file,
>  	}
>  
>  	lock_kernel();
> -	
> +

yeah.  I have a little script..
