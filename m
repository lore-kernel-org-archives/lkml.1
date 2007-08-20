Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbXHTAtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbXHTAtj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 20:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbXHTAt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 20:49:28 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:28013 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbXHTAt1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 20:49:27 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCPportsfrom the host TCP port space.
Date: Sun, 19 Aug 2007 17:47:59 -0700
Message-ID: <8A71B368A89016469F72CD08050AD334018E20BE@maui.asicdesigners.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate PS_TCPportsfrom the host TCP port space.
thread-index: AcfiwoBrETjN8S2jTlSvLdmE96hfCQAABCGQ
References: <8A71B368A89016469F72CD08050AD334018E209C@maui.asicdesigners.com><20070819.160428.76330262.davem@davemloft.net><8A71B368A89016469F72CD08050AD334018E20BC@maui.asicdesigners.com> <20070819.174017.77241227.davem@davemloft.net>
From: "Felix Marti" <felix@chelsio.com>
To: "David Miller" <davem@davemloft.net>
Cc: <sean.hefty@intel.com>, <netdev@vger.kernel.org>, <rdreier@cisco.com>,
       <general@lists.openfabrics.org>, <linux-kernel@vger.kernel.org>,
       <jeff@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem@davemloft.net]
> Sent: Sunday, August 19, 2007 5:40 PM
> To: Felix Marti
> Cc: sean.hefty@intel.com; netdev@vger.kernel.org; rdreier@cisco.com;
> general@lists.openfabrics.org; linux-kernel@vger.kernel.org;
> jeff@garzik.org
> Subject: Re: [ofa-general] Re: [PATCH RFC] RDMA/CMA: Allocate
> PS_TCPportsfrom the host TCP port space.
> 
> From: "Felix Marti" <felix@chelsio.com>
> Date: Sun, 19 Aug 2007 17:32:39 -0700
> 
> [ Why do you put that "[Felix Marti]" everywhere you say something?
>   It's annoying and superfluous. The quoting done by your mail client
>   makes clear who is saying what. ]
> 
> > Hmmm, interesting... I guess it is impossible to even have
> > a discussion on the subject.
> 
> Nice try, Herbert Xu gave a great explanation.
[Felix Marti] David and Herbert, so you agree that the user<>kernel
space memory copy overhead is a significant overhead and we want to
enable zero-copy in both the receive and transmit path? - Yes, copy
avoidance is mainly an API issue and unfortunately the so widely used
(synchronous) sockets API doesn't make copy avoidance easy, which is one
area where protocol offload can help. Yes, some apps can resort to
sendfile() but there are many apps which seem to have trouble switching
to that API... and what about the receive path?
