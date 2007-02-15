Return-Path: <linux-kernel-owner+w=401wt.eu-S1030380AbXBORwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030380AbXBORwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 12:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030382AbXBORwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 12:52:32 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:26892 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030380AbXBORwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 12:52:31 -0500
In-Reply-To: <20070215165228.GF4285@elte.hu>
References: <20070215165228.GF4285@elte.hu>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A0D7A9CD-B04B-4C54-A030-22B38DC50689@oracle.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [patch 05/14] syslets: core code
Date: Thu, 15 Feb 2007 09:46:12 -0800
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> +static void
> +__mark_async_thread_ready(struct async_thread *at, struct  
> async_head *ah)
> +{
> +	list_del(&at->entry);
> +	list_add_tail(&at->entry, &ah->ready_async_threads);

> +__mark_async_thread_busy(struct async_thread *at, struct  
> async_head *ah)
> +{
> +	list_del(&at->entry);
> +	list_add_tail(&at->entry, &ah->busy_async_threads);

list_move_tail()?

- z
