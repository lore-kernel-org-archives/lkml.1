Return-Path: <linux-kernel-owner+w=401wt.eu-S964821AbXBTLnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821AbXBTLnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 06:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932902AbXBTLnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 06:43:47 -0500
Received: from www.osadl.org ([213.239.205.134]:57796 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932901AbXBTLnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 06:43:46 -0500
Subject: Re: irqdesc porting help
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Maximus <john.maximus@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       arjan@infradead.org
In-Reply-To: <3634de740702192303xea41f14i9f613fac2725b0ca@mail.gmail.com>
References: <3634de740702142231k938a4c5ic824c2eefc95c1b0@mail.gmail.com>
	 <20070215103347.GA18690@linux-sh.org>
	 <3634de740702192303xea41f14i9f613fac2725b0ca@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 20 Feb 2007 12:48:46 +0100
Message-Id: <1171972126.30834.235.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-20 at 12:33 +0530, Maximus wrote:
> Hi,
>   Sorry for the late response, attached is the code im trying to port
> to linux - 2.6.20.

Why does this need to use a kernel thread in the first place ? Usually
chained handlers demultiplex the primary interrupt and invoke the
demultiplexed interrupts.

There are tons of working examples in arch/arm/mach-xxxx

	tglx


