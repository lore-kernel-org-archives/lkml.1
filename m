Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbZASTEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbZASTEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 14:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbZASTEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 14:04:08 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:59737 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752944AbZASTEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 14:04:07 -0500
Message-ID: <4974CEC5.9050402@ru.mvista.com>
Date: Mon, 19 Jan 2009 22:04:37 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] ide: move SFF I/O code to ide-io-sff.c
References: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>	<20090119130322.24745.76137.sendpatchset@localhost.localdomain>	<49748B95.9080105@ru.mvista.com>	<200901191523.15240.bzolnier@gmail.com>	<49748E43.4030009@ru.mvista.com>	<20090119173701.13fd24c6@lxorguk.ukuu.org.uk>	<4974C030.5020509@ru.mvista.com>	<20090119183607.5ee804e1@lxorguk.ukuu.org.uk>	<4974CA81.1050506@ru.mvista.com> <20090119184951.35a52184@lxorguk.ukuu.org.uk>
In-Reply-To: <20090119184951.35a52184@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

>>    Tried looking at how in*()/out*() are defined on x86?

> Tried looking at how ide_mm_inb is defined on x86

    That's a bogus argument because:
- MMIO isn't much used by the IDE drivers much (normally the inline
   ins*()/outs*() accessors are used;
- that's used only by generic IDE code, not by the drivers about which
   I'veargued;

I've already agreed that the generic code would probably win from using 
ioread*()/iowrite*().

>>>It's already making function calls, without the benefit of inlining and

>>    I'm afraid you're wrong here.

> I'm afraid you are the one who is wrong. The IDE layer is duplicating a
> generic level of indirection with its own code - purely because IDE
> pre-dates that core functionality. The whole IDE layer indirection can go
> away because Linux has caught up with the needs of the IDE layer.

    What IDE indirection you're talking about anyway?

> Alan

MBR, Sergei
