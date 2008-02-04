Return-Path: <linux-kernel-owner+w=401wt.eu-S1757690AbYBDWtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757690AbYBDWtk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 17:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbYBDWt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 17:49:29 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48461 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755610AbYBDWt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 17:49:27 -0500
Date: Mon, 4 Feb 2008 22:43:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Message-ID: <20080204224314.113afe7b@core>
In-Reply-To: <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	<1201639331.3069.58.camel@localhost.localdomain>
	<47A05CBD.5050803@vlnb.net>
	<47A7049A.9000105@vlnb.net>
	<1202139015.3096.5.camel@localhost.localdomain>
	<47A73C86.3060604@vlnb.net>
	<1202144767.3096.38.camel@localhost.localdomain>
	<47A7488B.4080000@vlnb.net>
	<1202145901.3096.49.camel@localhost.localdomain>
	<alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
	<1202151989.11265.576.camel@haakon2.linux-iscsi.org>
	<alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> better. So for example, I personally suspect that ATA-over-ethernet is way 
> better than some crazy SCSI-over-TCP crap, but I'm biased for simple and 
> low-level, and against those crazy SCSI people to begin with.

Current ATAoE isn't. It can't support NCQ. A variant that did NCQ and IP
would probably trash iSCSI for latency if nothing else.


Alan
