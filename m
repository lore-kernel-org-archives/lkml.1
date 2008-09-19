Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbYISKr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbYISKr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 06:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbYISKrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 06:47:49 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:56086 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbYISKrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 06:47:48 -0400
Date: Fri, 19 Sep 2008 12:47:45 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: AVR32: nmi_enter() without nmi_exit()
Message-ID: <20080919124745.0209cd06@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <48AC1EAF.9040906@colorfullife.com>
References: <48AC1EAF.9040906@colorfullife.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 19 Sep 2008 10:47:35.0714 (UTC) FILETIME=[2080B020:01C91A45]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul <manfred@colorfullife.com> wrote:
> You are listed as the maintainer for AVR32. If someone else is doing 
> that now, could you forward the mail?
> 
> While updating the rcu code, I noticed that do_nmi() for AVR32 is odd:
> There is an nmi_enter() call without an nmi_exit().
> This can't be correct, it breaks rcu (at least the preempt version) and 
> lockdep.
> 
> Attached is a patch, not tested at all.

Totally forgot about this, sorry.

Applied, thanks.

Haavard
