Return-Path: <linux-kernel-owner+w=401wt.eu-S1759160AbXLTMOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160AbXLTMOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759496AbXLTMC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:02:29 -0500
Received: from nz-out-0506.google.com ([64.233.162.224]:35811 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761562AbXLTMCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:02:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L2DgMWiTelScyUUYOIPjew6yJ5IAvKS8Envx6WvTxGzhyc0iacN2UgSTMztNyunE8RGP4LsBMo6sudYeEo29xyQT3jrJrB0Q/HBU1i2cwE3SkaBakCX6Jzb85tn9BYlv4gORuPXb4GQZxinz9N5PG6Xvqy7uCB0OFNawJMKChB8=
Message-ID: <1985e0f60712200402p78d453ffs240e02a8cd4bbd51@mail.gmail.com>
Date: Thu, 20 Dec 2007 17:32:23 +0530
From: "Jaswinder Singh" <jaswinderlinuxrt@gmail.com>
To: "Remy Bohmer" <linux@bohmer.net>
Subject: Re: [patch 2/3] Enable setting of IRQ-thread priorities from kernel cmdline (repost:CC to LKML)
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       "Ingo Molnar" <mingo@elte.hu>, "Juergen Beisert" <jbe@pengutronix.de>,
       "Darren Hart" <dvhltc@us.ibm.com>, linux-rt-users@vger.kernel.org,
       "Sven-Thorsten Dietrich" <sdietrich@novell.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47697882.2275420a.3951.ffff92ed@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071219194551.315868746@bohmer.net>
	 <47697882.2275420a.3951.ffff92ed@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/07, Remy Bohmer <linux@bohmer.net> wrote:
>  	struct task_struct	*thread;
> +	int                     rt_prio;
>  	wait_queue_head_t	wait_for_handler;

int rt_prio or unsigned int rt_prio, which one is better.

Thank you,

Jaswinder SIngh.
