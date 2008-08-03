Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbYHCNXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbYHCNXE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 09:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbYHCNWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 09:22:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51097 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754822AbYHCNWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 09:22:54 -0400
Date: Sun, 3 Aug 2008 14:02:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 15/25] drivers/serial to use nr_irqs
Message-ID: <20080803140205.6c8d6090@lxorguk.ukuu.org.uk>
In-Reply-To: <1217732365-16595-16-git-send-email-yhlu.kernel@gmail.com>
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-2-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-3-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-4-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-5-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-6-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-7-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-8-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-9-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-10-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-11-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-12-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-13-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-14-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-15-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-16-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -	for (i = 0; i < NR_IRQS; i++)
> +	for (i = 0; i < nr_irqs; i++)
>  		spin_lock_init(&irq_lists[i].lock);
> 

Don't you need to change how the array is allocated too ?
 

Alan
