Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbXKGGQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbXKGGQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 01:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbXKGGQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 01:16:12 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40004 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757433AbXKGGQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 01:16:10 -0500
Date: Tue, 6 Nov 2007 22:15:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Dubov <oakad@yahoo.com>
Cc: linux-kernel@vger.kernel.org, drzeus@drzeus.cx
Subject: Re: MemoryStick / Pro support
Message-Id: <20071106221537.12bffbac.akpm@linux-foundation.org>
In-Reply-To: <331462.7246.qm@web36703.mail.mud.yahoo.com>
References: <331462.7246.qm@web36703.mail.mud.yahoo.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 2 Nov 2007 06:23:48 -0700 (PDT) Alex Dubov <oakad@yahoo.com> wrote:
> After a much longer, than expected, time I managed to implement a support for MemoryStick (read-only currently, as there's still a subtle data corruption bug with writes) and MemoryStick Pro cards. The implementation follows the MMC driver model (there exist MSIO cards, but none are supported at the moment). The MS Pro support appears stable from what I can learn from user reports. Nevertheless, I've implemented a couple of diagnostics files in the "sys" filesystem, as well as low level format facility for legacy MS cards.
> 
> Currently only TI Flashmedia adapters are supported, but I'm working on a JMicron JMB38x adapter support and I know for sure that it'll be easy to support a Winbond 528 adapter, as I used its GPLed driver as a reference for  a more generic implementation.
> 
> I would like to get an advice on the way to arrange the files in the kernel tree. My current idea is:
> 
> memstick.h        -> include/linux

Or drivers/memstick/.  Will anything else need this header?

> memstick.c        -> drivers/memstick      ("bus" support)
> ms_block.c        -> drivers/memstick      (legacy MS storage support)
> mspro_block.c   -> drivers/memstick      (MS Pro storage support)
> tifm_ms.c          -> drivers/memstick      (TI Flashmedia low level driver)
> 
> 
> 
> I also wonder, where do I send the patches if nobody currently maintains this thing?
> 

Me, Pierre, lkml?
