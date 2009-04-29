Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbZD2T2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbZD2T2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbZD2T2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:28:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbZD2T2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:28:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@lst.de>, chris@zankel.net, cooloney@kernel.org,
       deller@gmx.de, geert@linux-m68k.org, gerg@uclinux.org,
       hskinnemoen@atmel.com, jdike@addtoit.com, jesper.nilsson@axis.com,
       kyle@mcmartin.ca, linux@arm.linux.org.uk, ralf@linux-mips.org,
       rth@twiddle.net, starvik@axis.com, takata@linux-m32r.org,
       ysato@users.sourceforge.jp, zippel@linux-m68k.org,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Fwd: arch/ && tracehook_report_syscall_xxx()
In-Reply-To: Oleg Nesterov's message of  Wednesday, 29 April 2009 21:08:52 +0200 <20090429190852.GA14515@redhat.com>
References: <20090427180455.GA32509@redhat.com>
	<20090427182919.B923DFC3BF@magilla.sf.frob.com>
	<20090427183218.GA31596@lst.de>
	<20090429190852.GA14515@redhat.com>
X-Shopping-List: (1) Lingering inflammation fiction
   (2) Enthusiastic contraptions
   (3) Mathematical constant combustion
   (4) Olympic Protrusion inflammations
   (5) Despotic snooze condiments
Message-Id: <20090429191744.DA422FC3BF@magilla.sf.frob.com>
Date: Wed, 29 Apr 2009 12:17:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph has already poked everyone, I believe.

> it would be really nice to turn it into something like
> 
> 	asmlinkage void
> 	syscall_trace(int entryexit)

We recommend replacing this with separate entry/exit paths from the
assembly code, if you are changing arch code anyway.


Thanks,
Roland
