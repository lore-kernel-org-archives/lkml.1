Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYFMVJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYFMVJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 17:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYFMVJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 17:09:10 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:36144 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbYFMVJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 17:09:09 -0400
Message-ID: <4852E1F1.4040900@users.sourceforge.net>
Date: Fri, 13 Jun 2008 23:09:05 +0200
From: =?ISO-8859-1?Q?Andr=E9_AUZI?= <aauzi@users.sourceforge.net>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Zbynek Hrabovsky <hrabosh@t-email.cz>, video4linux-list@redhat.com,
       Michel Lespinasse <walken@zoy.org>,
       Nicolas Marot <nicolas.marot@gmail.com>, linux-kernel@vger.kernel.org,
       nicolas <nicolas@nikoland.homelinux.org>
Subject: Re: [PATCH][RESEND] New type of DTV2000H TV Card
References: <20080207002224.e26d6bb1.hrabosh@t-email.cz> <20080613151843.240a62cb@gaivota>
In-Reply-To: <20080613151843.240a62cb@gaivota>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

forgive me if I jump in the conversation without invitation but I've got 
the same board and basically started the same task as you, Zbynek.

I'm still stuck with the radio support and your patch seems more 
advanced on the mpeg side.

Therefore, would you mind if I ask a question about what's proposed in 
the cx88-mpeg.c file?

> diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88-mpeg.c
> --- a/linux/drivers/media/video/cx88/cx88-mpeg.c	Tue Jun 10 15:27:29 2008 -0300
> +++ b/linux/drivers/media/video/cx88/cx88-mpeg.c	Fri Jun 13 15:07:34 2008 -0300
> @@ -148,6 +148,12 @@
>  			cx_write(TS_SOP_STAT, 0);
>  			cx_write(TS_VALERR_CNTRL, 0);
>  			udelay(100);
> +			break;
> +		case CX88_BOARD_WINFAST_DTV2000H_2:
> +			/* switch signal input to antena */
> +			cx_write(MO_GP0_IO, 0x00017300);
> +
> +			cx_write(TS_SOP_STAT, 0x00);
>  			break;
>  		default:
>  			cx_write(TS_SOP_STAT, 0x00);
>   

Correct me if I'm wrong but this change doesn't it prevent from 
processing data coming from the cable input?

Cheers,
André
