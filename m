Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbYIPIIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbYIPIIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 04:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYIPIIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 04:08:04 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:48983 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbYIPIIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 04:08:01 -0400
Date: Tue, 16 Sep 2008 10:06:22 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Marco Stornelli <marco.stornelli@coritel.it>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux AVR32 <kernel@avr32linux.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] avr32: added mem kernel command line option support
Message-ID: <20080916100622.36556a57@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <48CF5CBB.1050708@coritel.it>
References: <48CE33D7.1040203@coritel.it>
	<20080915074042.f5059467.randy.dunlap@oracle.com>
	<48CE77C6.90307@coritel.it>
	<20080915080517.5d75721e.randy.dunlap@oracle.com>
	<48CE7FA8.2020409@coritel.it>
	<20080915083622.062c4b5b.randy.dunlap@oracle.com>
	<48CF5CBB.1050708@coritel.it>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 16 Sep 2008 08:06:13.0456 (UTC) FILETIME=[16301D00:01C917D3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco Stornelli <marco.stornelli@coritel.it> wrote:
> User-Agent: Thunderbird 2.0.0.16 (X11/20080720)

Please see Documentation/email-clients.txt. Thunderbird apparently has
pretty braindead defaults, but can be taught to behave.

> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> Now is it ok? Sorry but it's the first time I submit a patch for the kernel.

Not really, sorry. This part is line-wrapped:

> --- linux-2.6.26.3/arch/avr32/kernel/setup.c.orig	2008-09-15
> 11:30:00.000000000 +0200
> +++ linux-2.6.26.3/arch/avr32/kernel/setup.c	2008-09-16
> 09:06:31.000000000 +0200

I've fixed it up, but I recommend that you send a few patches to
yourself and try to fix your setup. It's not much of a problem for a
small patch like this, but longer, more complicated ones may take quite
some time to unmangle.

The rest of the patch looks good. Although avr32 only supports 32-bit
physical addresses, I believe resource_size_t is more correct than
unsigned long.

Applied, thanks.

Haavard
