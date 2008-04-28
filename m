Return-Path: <linux-kernel-owner+w=401wt.eu-S934559AbYD1Nv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559AbYD1Nv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932153AbYD1NvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:51:18 -0400
Received: from mx2.netapp.com ([216.240.18.37]:6850 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765721AbYD1NvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:51:16 -0400
X-IronPort-AV: E=Sophos;i="4.25,716,1199692800"; 
   d="scan'208";a="44157209"
X-MimeOLE: Produced By Microsoft Exchange V6.5.7226.0
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [ofa-general] [PATCH 2.6.26 3/3] RDMA/cxgb3: Support peer-2-peerconnection setup.
Date: Mon, 28 Apr 2008 09:51:11 -0400
Message-ID: <C98692FD98048C41885E0B0FACD9DFB8078B23DC@exnane01.hq.netapp.com>
In-Reply-To: <4814AD7B.2060006@opengridcomputing.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [ofa-general] [PATCH 2.6.26 3/3] RDMA/cxgb3: Support peer-2-peerconnection setup.
Thread-Index: AciohgxutIWeBV4eRpaDkLBYYpGAnAAsLaTg
References: <20080427155456.31018.22282.stgit@dell3.ogc.int>	<20080427160010.31018.67436.stgit@dell3.ogc.int><adatzhn2r5z.fsf@cisco.com> <4814AD7B.2060006@opengridcomputing.com>
From: "Kanevsky, Arkady" <Arkady.Kanevsky@netapp.com>
To: "Steve Wise" <swise@opengridcomputing.com>,
       "Roland Dreier" <rdreier@cisco.com>
Cc: <netdev@vger.kernel.org>, <general@lists.openfabrics.org>,
       <linux-kernel@vger.kernel.org>, <divy@chelsio.com>
X-OriginalArrivalTime: 28 Apr 2008 13:51:13.0926 (UTC) FILETIME=[EC626A60:01C8A936]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I expect it to be tests at Sept interop event.
If it works then I will send proposal to IETF for MPA enhancement.
Thanks,

Arkady Kanevsky                       email: arkady@netapp.com
Network Appliance Inc.               phone: 781-768-5395
1601 Trapelo Rd. - Suite 16.        Fax: 781-895-1195
Waltham, MA 02451                   central phone: 781-768-5300
 

> -----Original Message-----
> From: Steve Wise [mailto:swise@opengridcomputing.com] 
> Sent: Sunday, April 27, 2008 12:45 PM
> To: Roland Dreier
> Cc: netdev@vger.kernel.org; general@lists.openfabrics.org; 
> linux-kernel@vger.kernel.org; divy@chelsio.com
> Subject: Re: [ofa-general] [PATCH 2.6.26 3/3] RDMA/cxgb3: 
> Support peer-2-peerconnection setup.
> 
> 
> 
> Roland Dreier wrote:
> > What are the interoperability implications of this?
> > 
> > Looking closer I see that iw_nes has the send_first module 
> parameter.
> > How does this interact with that?
> > 
> 
> It doesn't...yet.  But we wanted to enable these applications 
> for chelsio now and get the low level fw and driver changes 
> done first and tested.
> 
> > I guess it's fine to apply this, but do we have a plan for 
> how we want 
> > to handle this issue in the long-term?
> > 
> 
> Yes!  If you'll recall, we had a thread on the ofa general 
> list discussing how to enhance the MPA negotiation so peers 
> can indicate whether they want/need the RTR and what type of 
> RTR (0B read, 0B write, or 0B send) should be sent.  This 
> will be done by standardizing a few bits of the private data 
> in order to negotiate all this.  The rdma-cma API will be 
> extended so applications will have to request this 
> peer-2-peer model since it adds overhead to the connection setup.
> 
> I plan to do this work for 2.6.27/ofed-1.4.  I think it was 
> listed in Felix's talk at Sonoma.  This work (design, API, 
> and code changes affecting core and placing requirements on 
> iwarp providers) will be posted as RFC changes to get 
> everyones feedback as soon as I get something going.
> 
> Does that sound ok?
> 
> 
> Steve.
> _______________________________________________
> general mailing list
> general@lists.openfabrics.org
> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general
> 
> To unsubscribe, please visit 
> http://openib.org/mailman/listinfo/openib-general
> 
