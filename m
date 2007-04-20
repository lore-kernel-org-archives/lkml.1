Return-Path: <linux-kernel-owner+w=401wt.eu-S1767191AbXDTSjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767191AbXDTSjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 14:39:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767189AbXDTSjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 14:39:47 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46996 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767188AbXDTSjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 14:39:46 -0400
Date: Fri, 20 Apr 2007 11:38:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: David Miller <davem@davemloft.net>, ebiederm@xmission.com,
       containers@lists.osdl.org, oleg@tv-sign.ru, hch@infradead.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Getting the new RxRPC patches upstream
Message-Id: <20070420113805.c4877dc8.akpm@linux-foundation.org>
In-Reply-To: <4713.1177065706@redhat.com>
References: <20070420.015838.83621529.davem@davemloft.net>
	<29341.1176975158@redhat.com>
	<2969.1176992303@redhat.com>
	<1101.1177056127@redhat.com>
	<4713.1177065706@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 11:41:46 +0100
David Howells <dhowells@redhat.com> wrote:

> There are only two non-net patches that AF_RXRPC depends on:
> 
>  (1) The key facility changes.  That's all my code anyway, and shouldn't be a
>      problem to merge unless someone else has put some changes in there that I
>      don't know about.
> 
>  (2) try_to_cancel_delayed_work().  I suppose I could use
>      cancel_delayed_work() instead, but that's less efficient as it waits for
>      the timer completion function to finish.

There are significant workqueue changes in -mm and I plan to send them
in for 2.6.22.  I doubt if there's anything in there which directly
affects cancel_delayed_work(), but making changes of this nature against
2.6.21 might lead to grief.
