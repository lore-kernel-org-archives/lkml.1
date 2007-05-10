Return-Path: <linux-kernel-owner+w=401wt.eu-S1762705AbXEJO2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762705AbXEJO2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbXEJO22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:28:28 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41393 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750844AbXEJO21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:28:27 -0400
Date: Thu, 10 May 2007 15:32:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "liang yuanen" <linux.kernel.liang@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: why are we reduce spin-lock and replace it with lock-free?
Message-ID: <20070510153241.2d5ac2cb@the-village.bc.nu>
In-Reply-To: <76391b770705100723w24c93b99m48180a759d2116c7@mail.gmail.com>
References: <76391b770705100723w24c93b99m48180a759d2116c7@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 22:23:32 +0800
"liang yuanen" <linux.kernel.liang@gmail.com> wrote:

> Three are many many spin-lock in the kernel code, and in multi-core
> conditions, it push down the kernel performance.why are we reduce
> spin-lock and replace it with lock-free?

If you can find algorithms which are lock free, faster than taking the
lock and have bounded resource consumption then you can test them with
the kernel and send patches. 

Alan
