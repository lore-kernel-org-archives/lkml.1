Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbYHCNXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbYHCNXZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 09:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbYHCNXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 09:23:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51101 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754855AbYHCNXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 09:23:09 -0400
Date: Sun, 3 Aug 2008 14:03:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 21/25] serial: change remove NR_IRQS in 8250.c v2
Message-ID: <20080803140350.2f0e92f4@lxorguk.ukuu.org.uk>
In-Reply-To: <1217732365-16595-22-git-send-email-yhlu.kernel@gmail.com>
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-8-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-9-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-10-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-11-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-12-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-13-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-14-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-15-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-16-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-17-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-18-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-19-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-20-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-21-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-22-git-send-email-yhlu.kernel@gmail.com>
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

On Sat,  2 Aug 2008 19:59:21 -0700
Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> use small array with index to handle irq locking for serial port
> hope 32 slot is enough
> 
> v2: according to Eric, move irq_no into irq_info, and not clean irq_no

This wants doing with a hash not a prayer that "32 slots is enough"
