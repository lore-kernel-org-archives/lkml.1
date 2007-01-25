Return-Path: <linux-kernel-owner+w=401wt.eu-S1030610AbXAYVty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030610AbXAYVty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 16:49:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030612AbXAYVty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 16:49:54 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:51024 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030611AbXAYVtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 16:49:53 -0500
Message-ID: <45B92536.2080909@lwfinger.net>
Date: Thu, 25 Jan 2007 15:46:30 -0600
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bcm43xx oops after suspend to disk
References: <45B92488.6090908@lwfinger.net>
In-Reply-To: <45B92488.6090908@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

roucaries bastien wrote:
> My bcm43xx oops after suspend to disk on a 2.6.20rc5 kernel (preempt+smp).
> 
> ---------------
> Jan 25 19:47:39 portablebastien kernel: caller is oops_begin+0xb/0x80
> Jan 25 19:47:39 portablebastien kernel:
> Jan 25 19:47:39 portablebastien kernel: Call Trace:
> Jan 25 19:47:39 portablebastien kernel: [<ffffffff8033f1eb>]
> debug_smp_processor_id+0xab/0xc0
> Jan 25 19:47:39 portablebastien kernel: [<ffffffff8026d52b>]
> oops_begin+0xb/0x80
> Jan 25 19:47:39 portablebastien kernel: [<ffffffff8020aee4>]
> do_page_fault+0x6e4/0x890
> Jan 25 19:47:39 portablebastien kernel: [<ffffffff8022f383>]
> __wake_up+0x43/0x70
> Jan 25 19:47:39 portablebastien kernel: [<ffffffff80269416>]
> _spin_unlock_irqrestore+0x16/0x40
> 

Do you have the log stuff that precedes this part? In particular, was there a assertion that failed?

Thanks,

Larry

