Return-Path: <linux-kernel-owner+w=401wt.eu-S1758694AbYDBQrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758694AbYDBQrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759345AbYDBQqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:46:54 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:36149 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbYDBQqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:46:53 -0400
X-IronPort-AV: E=Sophos;i="4.25,594,1199692800"; 
   d="scan'208";a="19668159"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [ofa-general] InfiniBand/iWARP/RDMA merge plans for 2.6.26 (what'sin infiniband.git)
Date: Wed, 2 Apr 2008 09:46:48 -0700
Message-ID: <A15335FBE9BD2449AF2C9EF3D1EB8EA30554720D@xmb-sjc-216.amer.cisco.com>
In-Reply-To: <47F3C469.1020803@oracle.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [ofa-general] InfiniBand/iWARP/RDMA merge plans for 2.6.26 (what'sin infiniband.git)
Thread-Index: AciU4Bv91FuNrY+NTJG6Vi93KaSbJAAAIY6w
References: <adave31bayd.fsf@cisco.com>	<1207120932.4593.47.camel@localhost.localdomain>	<aday77w2s5z.fsf@cisco.com><47F3BE33.4000204@oracle.com> <adalk3w2pxz.fsf@cisco.com> <47F3C137.3070209@oracle.com> <A15335FBE9BD2449AF2C9EF3D1EB8EA3055471E8@xmb-sjc-216.amer.cisco.com> <47F3C469.1020803@oracle.com>
From: "Scott Weitzenkamp (sweitzen)" <sweitzen@cisco.com>
To: "Richard Frank" <richard.frank@oracle.com>,
       "Scott Weitzenkamp (sweitzen)" <sweitzen@cisco.com>
Cc: "Roland Dreier (rdreier)" <rdreier@cisco.com>, <rds-devel@oss.oracle.com>,
       <linux-kernel@vger.kernel.org>, <general@lists.openfabrics.org>
X-OriginalArrivalTime: 02 Apr 2008 16:46:52.0423 (UTC) FILETIME=[2713F170:01C894E1]
Authentication-Results: sj-dkim-2; header.From=sweitzen@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rich,

On Nov 1, 2007, you wrote this to rds-devel:

  "Netperf is too simplistic in that all it seems to do is stream data
in a 
  simple loop. This is not how Oracle uses the IPC and again does not 
  reflect what it would take to make UDP reliable.

  For this reason we are not interested in having Netperf support RDS
and 
  or seeing Netperf data."

I would like to see RDS supported by existing common tools like netperf,
iperf, etc. so we can easily compare how RDS performs to UDP for IPC
models other than Oracle.

Scott Weitzenkamp
SQA and Release Manager
Data Center Access Engineering
Cisco Systems


 

> -----Original Message-----
> From: Richard Frank [mailto:richard.frank@oracle.com] 
> Sent: Wednesday, April 02, 2008 10:38 AM
> To: Scott Weitzenkamp (sweitzen)
> Cc: Roland Dreier (rdreier); rds-devel@oss.oracle.com; 
> linux-kernel@vger.kernel.org; general@lists.openfabrics.org
> Subject: Re: [ofa-general] InfiniBand/iWARP/RDMA merge plans 
> for 2.6.26 (what'sin infiniband.git)
> 
> I believe there is a patch for NetPerf which supports RDS - 
> although it 
> may need to be updated - and submitted.
> 
> The only prior discussion I can think of - was whether or not NetPerf 
> exercises RDS as Oracle would.
> 
> I'm not proposing that we should enhance NetPerf to do that 
> (but that's 
> OK with me).
> 
> We created a tool rds-stress which does that.
> 
> Scott Weitzenkamp (sweitzen) wrote:
> >> WRT to merging RDS into the kernel - our current plans are 
> to wait to 
> >> see RDS adopted by more than Oracle - before approaching 
> the kernel 
> >> community about inclusion of RDS.
> >>     
> >
> > I've seen statements before from someone from Oracle that 
> RDS was only
> > for Oracle's use, for example, that person did not want 
> netperf changed
> > to support RDS.
> >
> > Scott Weitzenkamp
> > SQA and Release Manager
> > Data Center Access Engineering
> > Cisco Systems
> >   
> 
