Return-Path: <linux-kernel-owner+w=401wt.eu-S932182AbXLNLDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbXLNLDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 06:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761617AbXLNLDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 06:03:25 -0500
Received: from www.tglx.de ([62.245.132.106]:55580 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760954AbXLNLDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 06:03:24 -0500
Date: Fri, 14 Dec 2007 12:03:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Miao Xie <miaox@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time: add an offline-cpu check in add_timer_on()
In-Reply-To: <47625B94.50105@cn.fujitsu.com>
Message-ID: <alpine.LFD.0.99999.0712141201370.10584@localhost.localdomain>
References: <47625B94.50105@cn.fujitsu.com>
User-Agent: Alpine 0.99999 (LFD 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007, Miao Xie wrote:

> Hi everyone,
>   I think we need a check in the function add_timer_on() to avoid adding a
> timer into the timer list of an offline cpu.
> 
> This patch fixes this problem in add_timer_on().

No, the patch is not fixing the problem. It crashes the machine.

Where did you run into this problem ?

Thanks,

	tglx

