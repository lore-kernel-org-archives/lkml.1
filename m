Return-Path: <linux-kernel-owner+w=401wt.eu-S1763208AbYESVQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763208AbYESVQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758227AbYESVQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:16:25 -0400
Received: from smtp.innovsys.com ([66.115.232.196]:19490 "EHLO
	mail.innovsys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753429AbYESVQY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:16:24 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Oops with PREEMPT-RT on 2.6.25.4
Date: Mon, 19 May 2008 16:16:34 -0500
Message-ID: <DCEAAC0833DD314AB0B58112AD99B93B04690239@ismail.innsys.innovsys.com>
In-Reply-To: <4831ECF0.5090101@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Oops with PREEMPT-RT on 2.6.25.4
Thread-Index: Aci59MQ2pEcc2XMxS0WeXyHm575XFQAAEO7Q
References: <DCEAAC0833DD314AB0B58112AD99B93B0469010C@ismail.innsys.innovsys.com>	<4831D527.2020907@freescale.com> <DCEAAC0833DD314AB0B58112AD99B93B04690162@ismail.innsys.innovsys.com> <4831ECF0.5090101@freescale.com>
From: "Rune Torgersen" <runet@innovsys.com>
To: "Scott Wood" <scottwood@freescale.com>
Cc: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>,
       <linux-ide@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood wrote:
> Almost certainly the latter.  Is the disk interrupt shared with any
> other interrupts, that are marked IRQF_NODELAY?  The -rt
> patch doesn't seem to handle mixing the two well.

Disk is on a muxed PCI interrupt. None of the other interrupts on the
mux is fireing at the time.
Is is possible that the demuxer is not set up right? It is based loosely
on pq2-pci-pic.c

 
> Oh, and just to be sure: you do have CONFIG_PREEMPT_RT turned on, and
> not just CONFIG_PREEMPT, right?  The non-preempt-rt versions in the
-rt
> patch don't look like they disable interrupts, though I may just be
> getting lost in a sea of underscores and ifdefs.

Full CONFIG_PREEMPT_RT. I was actually going to try CONFIG_PREEMPT to
see if anything helped.

