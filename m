Return-Path: <linux-kernel-owner+w=401wt.eu-S932674AbYBTU0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674AbYBTU0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933591AbYBTUZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:25:36 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44393 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933245AbYBTUZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:25:35 -0500
Date: Wed, 20 Feb 2008 20:07:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rik van Riel <riel@redhat.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       oleg@tv-sign.ru, roland@redhat.com, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.25-rc2-mm1 - Kernel panic while bootup caused by
 signal_group_exit()
Message-ID: <20080220200732.1d01f7b8@core>
In-Reply-To: <20080220143417.6e419c5e@cuia.boston.redhat.com>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
	<47B7B3B9.2090706@linux.vnet.ibm.com>
	<20080220143417.6e419c5e@cuia.boston.redhat.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 14:34:17 -0500
Rik van Riel <riel@redhat.com> wrote:

> On Sun, 17 Feb 2008 09:40:33 +0530
> Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > [   25.512919] BUG: unable to handle kernel paging request at 9d74e37b
> > [   25.514926] IP: [<c04a8fac>] proc_flush_task+0x5b/0x223
> 
> I wonder if this one is related.   Also with 2.6.25-rc2-mm1 on x86_64:

Probably - am testing some locking patches now
