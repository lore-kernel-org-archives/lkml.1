Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbYBETMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbYBETMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbYBETM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 14:12:27 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45668 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbYBETM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 14:12:26 -0500
Message-ID: <47A8B510.8000807@garzik.org>
Date: Tue, 05 Feb 2008 14:12:16 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Vladislav Bolkhovitin <vst@vlnb.net>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Mike Christie <michaelc@cs.wisc.edu>,
       linux-scsi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       scst-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Integration of SCST in the mainstream Linux kernel
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>	<1201639331.3069.58.camel@localhost.localdomain>	<47A05CBD.5050803@vlnb.net>	<47A7049A.9000105@vlnb.net>	<1202139015.3096.5.camel@localhost.localdomain>	<47A73C86.3060604@vlnb.net>	<1202144767.3096.38.camel@localhost.localdomain>	<47A7488B.4080000@vlnb.net>	<1202145901.3096.49.camel@localhost.localdomain>	<alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>	<1202151989.11265.576.camel@haakon2.linux-iscsi.org>	<alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>	<20080204224314.113afe7b@core> <47A79A10.4070706@garzik.org> <47A8B29B.8050406@vlnb.net>
In-Reply-To: <47A8B29B.8050406@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vladislav Bolkhovitin wrote:
> Jeff Garzik wrote:
>> iSCSI is way, way too complicated. 
> 
> I fully agree. From one side, all that complexity is unavoidable for 
> case of multiple connections per session, but for the regular case of 
> one connection per session it must be a lot simpler.


Actually, think about those multiple connections...  we already had to 
implement fast-failover (and load bal) SCSI multi-pathing at a higher 
level.  IMO that portion of the protocol is redundant:   You need the 
same capability elsewhere in the OS _anyway_, if you are to support 
multi-pathing.

	Jeff



