Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbYBDXA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbYBDXA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbYBDXAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:00:17 -0500
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:31941 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754748AbYBDXAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:00:14 -0500
X-YMail-OSG: WFE4N18VM1knbxyQGDg4wFfr_ENlHuverf2y1ILUXv2LFSZxkmT1onfzdYsh8n4tLZQZMdjGSKN8QkPFeBm__4pcprdxAa7CSi1QFJkxG2Qob6VooZM-
X-Yahoo-Newman-Property: ymail-3
Subject: Re: Integration of SCST in the mainstream Linux kernel
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Julian Satran <Julian_Satran@il.ibm.com>
In-Reply-To: <20080204224314.113afe7b@core>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net>
	 <1202139015.3096.5.camel@localhost.localdomain> <47A73C86.3060604@vlnb.net>
	 <1202144767.3096.38.camel@localhost.localdomain>
	 <47A7488B.4080000@vlnb.net>
	 <1202145901.3096.49.camel@localhost.localdomain>
	 <alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>
	 <1202151989.11265.576.camel@haakon2.linux-iscsi.org>
	 <alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>
	 <20080204224314.113afe7b@core>
Content-Type: text/plain
Date: Mon, 04 Feb 2008 14:59:40 -0800
Message-Id: <1202165980.11265.653.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-04 at 22:43 +0000, Alan Cox wrote:
> > better. So for example, I personally suspect that ATA-over-ethernet is way 
> > better than some crazy SCSI-over-TCP crap, but I'm biased for simple and 
> > low-level, and against those crazy SCSI people to begin with.
> 
> Current ATAoE isn't. It can't support NCQ. A variant that did NCQ and IP
> would probably trash iSCSI for latency if nothing else.
> 

In the previous iSCSI vs. FCoE points (here is the link again):

http://www.ietf.org/mail-archive/web/ips/current/msg02325.html

the latency discussion is the one bit that is not mentioned.  I always
assumed that back then (as with today) the biggest issue was getting
ethernet hardware, espically switching equipment down to the sub
millisecond latency, and on par with what you would expect from 'real
RDMA' hardware.  In lowest of the low, say sub 10 ns latency, which is
apparently possible with point to point on high-end 10 Gb/sec adapters
today, it would be really interesting to know how much more latency
would be expected between software iSCSI vs. *oE when we work our way
back up the networking stack.

Julo, do you have any idea on this..?

--nab

> 
> Alan
> 

