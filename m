Return-Path: <linux-kernel-owner+w=401wt.eu-S1758165AbYBDXFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165AbYBDXFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbYBDXFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:05:06 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:53940 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619AbYBDXFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:05:04 -0500
Message-ID: <47A79A10.4070706@garzik.org>
Date: Mon, 04 Feb 2008 18:04:48 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Integration of SCST in the mainstream Linux kernel
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>	<1201639331.3069.58.camel@localhost.localdomain>	<47A05CBD.5050803@vlnb.net>	<47A7049A.9000105@vlnb.net>	<1202139015.3096.5.camel@localhost.localdomain>	<47A73C86.3060604@vlnb.net>	<1202144767.3096.38.camel@localhost.localdomain>	<47A7488B.4080000@vlnb.net>	<1202145901.3096.49.camel@localhost.localdomain>	<alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>	<1202151989.11265.576.camel@haakon2.linux-iscsi.org>	<alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org> <20080204224314.113afe7b@core>
In-Reply-To: <20080204224314.113afe7b@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> better. So for example, I personally suspect that ATA-over-ethernet is way 
>> better than some crazy SCSI-over-TCP crap, but I'm biased for simple and 
>> low-level, and against those crazy SCSI people to begin with.
> 
> Current ATAoE isn't. It can't support NCQ. A variant that did NCQ and IP
> would probably trash iSCSI for latency if nothing else.

AoE is truly a thing of beauty.  It has a two/three page RFC (say no more!).

But quite so...  AoE is limited to MTU size, which really hurts.  Can't 
really do tagged queueing, etc.


iSCSI is way, way too complicated.  It's an Internet protocol designed 
by storage designers, what do you expect?

For years I have been hoping that someone will invent a simple protocol 
(w/ strong auth) that can transit ATA and SCSI commands and responses. 
Heck, it would be almost trivial if the kernel had a TLS/SSL implementation.

	Jeff



