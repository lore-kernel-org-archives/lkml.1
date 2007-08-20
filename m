Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbXHTBrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbXHTBrK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 21:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbXHTBqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 21:46:55 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:1594 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbXHTBqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 21:46:53 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCPportsfrom the host TCP port space.
Date: Sun, 19 Aug 2007 18:45:24 -0700
Message-ID: <8A71B368A89016469F72CD08050AD334018E20C2@maui.asicdesigners.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCPportsfrom the host TCP port space.
thread-index: AcfisNOH4sy1Ov+yQUinpjObdkRWNQAGnKDg
References: <000001c7e22e$b7b90f00$29c8180a@amr.corp.intel.com><20070819.002337.06589160.davem@davemloft.net><8A71B368A89016469F72CD08050AD334018E208F@maui.asicdesigners.com><20070819.123212.13769462.davem@davemloft.net><8A71B368A89016469F72CD08050AD334018E209C@maui.asicdesigners.com> <p73hcmv14wo.fsf@bingen.suse.de>
From: "Felix Marti" <felix@chelsio.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "David Miller" <davem@davemloft.net>, <jeff@garzik.org>,
       <netdev@vger.kernel.org>, <rdreier@cisco.com>,
       <linux-kernel@vger.kernel.org>, <general@lists.openfabrics.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: ak@suse.de [mailto:ak@suse.de] On Behalf Of Andi Kleen
> Sent: Sunday, August 19, 2007 4:28 PM
> To: Felix Marti
> Cc: David Miller; jeff@garzik.org; netdev@vger.kernel.org;
> rdreier@cisco.com; linux-kernel@vger.kernel.org;
> general@lists.openfabrics.org
> Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate
> PS_TCPportsfrom the host TCP port space.
> 
> "Felix Marti" <felix@chelsio.com> writes:
> 
> > what benefits does the TSO infrastructure give the
> > non-TSO capable devices?
> 
> It improves performance on software queueing devices between guests
> and hypervisors. This is a more and more important application these
> days.  Even when the system running the Hypervisor has a non TSO
> capable device in the end it'll still save CPU cycles this way. Right
> now
> virtualized IO tends to much more CPU intensive than direct IO so any
> help it can get is beneficial.
> 
> It also makes loopback faster, although given that's probably not that
> useful.
> 
> And a lot of the "TSO infrastructure" was needed for zero copy TX
> anyways,
> which benefits most reasonable modern NICs (anything with hardware
> checksumming)
Hi Andi, yes, you're right. I should have chosen my example more
carefully.

> 
> -Andi
