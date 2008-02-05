Return-Path: <linux-kernel-owner+w=401wt.eu-S1759468AbYBETB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbYBETB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 14:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759853AbYBETBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 14:01:45 -0500
Received: from mail-relay-01.mailcluster.net ([77.221.130.213]:45258 "EHLO
	mail-relay-01.mailcluster.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752077AbYBETBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 14:01:44 -0500
Message-ID: <47A8B29B.8050406@vlnb.net>
Date: Tue, 05 Feb 2008 22:01:47 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc5
X-Accept-Language: en-us, ru, en
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
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
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>	<1201639331.3069.58.camel@localhost.localdomain>	<47A05CBD.5050803@vlnb.net>	<47A7049A.9000105@vlnb.net>	<1202139015.3096.5.camel@localhost.localdomain>	<47A73C86.3060604@vlnb.net>	<1202144767.3096.38.camel@localhost.localdomain>	<47A7488B.4080000@vlnb.net>	<1202145901.3096.49.camel@localhost.localdomain>	<alpine.LFD.1.00.0802041018390.3034@hp.linux-foundation.org>	<1202151989.11265.576.camel@haakon2.linux-iscsi.org>	<alpine.LFD.1.00.0802041130140.3034@hp.linux-foundation.org>	<20080204224314.113afe7b@core> <47A79A10.4070706@garzik.org>
In-Reply-To: <47A79A10.4070706@garzik.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Alan Cox wrote:
> 
>>>better. So for example, I personally suspect that ATA-over-ethernet is way 
>>>better than some crazy SCSI-over-TCP crap, but I'm biased for simple and 
>>>low-level, and against those crazy SCSI people to begin with.
>>
>>Current ATAoE isn't. It can't support NCQ. A variant that did NCQ and IP
>>would probably trash iSCSI for latency if nothing else.
> 
> 
> AoE is truly a thing of beauty.  It has a two/three page RFC (say no more!).
> 
> But quite so...  AoE is limited to MTU size, which really hurts.  Can't 
> really do tagged queueing, etc.
> 
> 
> iSCSI is way, way too complicated. 

I fully agree. From one side, all that complexity is unavoidable for 
case of multiple connections per session, but for the regular case of 
one connection per session it must be a lot simpler.

And now think about iSER, which brings iSCSI on the whole new complexity 
level ;)

> It's an Internet protocol designed 
> by storage designers, what do you expect?
> 
> For years I have been hoping that someone will invent a simple protocol 
> (w/ strong auth) that can transit ATA and SCSI commands and responses. 
> Heck, it would be almost trivial if the kernel had a TLS/SSL implementation.
> 
> 	Jeff
