Return-Path: <linux-kernel-owner+w=401wt.eu-S966166AbXHaSlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966166AbXHaSlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 14:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965908AbXHaSlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 14:41:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48282 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965790AbXHaSk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 14:40:59 -0400
Date: Fri, 31 Aug 2007 11:40:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3/3] V4L: stk11xx, add static to tables
Message-Id: <20070831114047.4679330b.akpm@linux-foundation.org>
In-Reply-To: <2680630254888919558@pripojeni.net>
References: <12315207221202319057@pripojeni.net>
	<2680630254888919558@pripojeni.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007 01:18:34 -0700
Jiri Slaby <jirislaby@gmail.com> wrote:

> stk11xx, add static to tables
> 
> ensure, that the compiler will put all the tables in static storage
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> 
> ...
> 
> diff --git a/drivers/media/video/stk1125.c b/drivers/media/video/stk1125.c
> index f12030d..d79c196 100644
> --- a/drivers/media/video/stk1125.c
> +++ b/drivers/media/video/stk1125.c
> @@ -26,7 +26,7 @@ static int stk1125_load_microcode(struct stk11xx *dev)
>  	int retok;
>  
>  	/* From 80x60 to 640x480 */
> -	const u8 values_1_204[] = {
> +	static const u8 values_1_204[] = {
>  		0x12, 0x11, 0x3b, 0x6a, 0x13, 0x10, 0x00, 0x01, 0x02, 0x13,
>  		0x39, 0x38, 0x37, 0x35, 0x0e, 0x12, 0x04, 0x0c, 0x0d, 0x17,

I think you'll find that the compiler is already putting this array into
static storage.  But yes, I think the change is useful for commentary and
peace-of-mind reasons.


