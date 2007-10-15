Return-Path: <linux-kernel-owner+w=401wt.eu-S932874AbXJOSSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874AbXJOSSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbXJOSR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:17:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56626 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbXJOSR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:17:56 -0400
Date: Mon, 15 Oct 2007 11:15:53 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: thomas.mingarelli@hp.com
Cc: linux-kernel@vger.kernel.org, thomas.mingarelli@hp.com
Subject: Re: [HP ProLiant WatchDog driver] hpwdt HP WatchDog Patch
Message-ID: <20071015111553.1b8e6125@laptopd505.fenrus.org>
In-Reply-To: <20071015130312.13901.89895.sendpatchset@tmingo.cca.cpqcorp.net>
References: <20071015130312.13901.89895.sendpatchset@tmingo.cca.cpqcorp.net>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 14:05:50 -0400 (EDT)
thomas.mingarelli@hp.com wrote:

> Hp is providing a Hardware WatchDog Timer driver that will only work
> with the specific HW Timer located in the HP ProLiant iLO 2 ASIC. The
> iLO 2 HW Timer will generate a Non-maskable Interrupt (NMI) 9 seconds
> before physically resetting the server, by removing power, so that
> the event can be logged to the HP Integrated Management Log (IML), a
> Non-Volatile Random Access Memory (NVRAM). The logging of the event
> is performed using the HP ProLiant ROM via an Industry Standard
> access known as a BIOS Service Directory Entry.


Hi,

Your patch looks quite clean in general; however it does make me wonder
if it should either leverage or expand the arch/x86/pci/pcbios.c
infrastructure for doing BIOS32 calls and share that.... it's kinda
unpleasant as a general thought to have drivers poke this deep into
various guts of the system/bios.... esp if the common code has to do
something very similar already.

Greetings,
   Arjan van de Ven
