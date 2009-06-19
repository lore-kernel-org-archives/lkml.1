Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbZFSNpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbZFSNpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 09:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbZFSNo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 09:44:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47250 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757773AbZFSNo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 09:44:57 -0400
Date: Fri, 19 Jun 2009 14:44:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sudeep K N <sudeepholla.maillist@gmail.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: Re: Rootfs in eMMC: Kernel panic ...Attempted to kill init!
Message-ID: <20090619134446.GI24573@n2100.arm.linux.org.uk>
References: <366f00c80906180218p539f9df9md30f629787fabeb2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <366f00c80906180218p539f9df9md30f629787fabeb2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 02:48:10PM +0530, Sudeep K N wrote:
> After mounting the rootfs in eMMC, it panics.
> Panic log as below.  When I traced, I observed it fails while its
> execution "run_init_process"
> I have tried with different init process,i.e. init=/linuxrc,
> init=/bin/busybox, init=/sbin/init
> Even I tried initramfs and the switch_root/pivot_root to rootfs on
> eMMC partition.
> In all the cases, I got the same panic.
> Can anybody help me in understanding the exact reason for this panic?

Enable CONFIG_DEBUG_USER and pass user_debug=31 - that should get
more detail on the problem that's killing init.
