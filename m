Return-Path: <linux-kernel-owner+w=401wt.eu-S933921AbXEEV4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921AbXEEV4S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 17:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933965AbXEEV4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 17:56:18 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48744 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933921AbXEEV4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 17:56:17 -0400
Date: Sat, 5 May 2007 23:00:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Clifford Wolf <clifford@clifford.at>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Interrupt-Handling in User Space
Message-ID: <20070505230026.4b2f4030@the-village.bc.nu>
In-Reply-To: <20070505191707.GA9300@clifford.at>
References: <20070505191707.GA9300@clifford.at>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> afaics there is no mechanism in the official kernel tree to handle
> interrupts in user space yet. I'd need that for an embedded project I'm

Its basically not possible to do with most hardware because you get
deadlocks when there are shared interrupts.

However see drivers/uio in the current GIT tree (or recent -mm kernels),
that assumes you write a truely minimal IRQ handler/board driver in the
kernel and it then exposes the memory spaces and IRQ stream to user space.
