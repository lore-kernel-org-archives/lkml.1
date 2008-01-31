Return-Path: <linux-kernel-owner+w=401wt.eu-S934260AbYAaSQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934260AbYAaSQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 13:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757397AbYAaSQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 13:16:10 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:35441 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753566AbYAaSQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 13:16:07 -0500
X-YMail-OSG: Nyvbn70VM1k_brYu7ACKPEZb5aeWaa00gXAPQoUo8qgveol9j4DyyIotgW.IOh_HQbYJOPMH4EvNedEFQ5Y2z2Ft_l5_1xjqWw.qfBWkX7PmMsHqsA--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: Integration of SCST in the mainstream Linux kernel
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, FUJITA Tomonori <tomof@acm.org>,
       fujita.tomonori@lab.ntt.co.jp, rdreier@cisco.com,
       James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <e2e108260801310940s5a6e963cva6c106a82388065f@mail.gmail.com>
References: <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <20080130195635T.tomof@acm.org>
	 <1201785938.7280.105.camel@haakon2.linux-iscsi.org>
	 <e2e108260801310634n21473909o5abac021cc889de3@mail.gmail.com>
	 <47A1EE54.6000005@vlnb.net>
	 <1201799660.11265.121.camel@haakon2.linux-iscsi.org>
	 <e2e108260801310940s5a6e963cva6c106a82388065f@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 10:15:39 -0800
Message-Id: <1201803339.11265.166.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-31 at 18:40 +0100, Bart Van Assche wrote:
> On Jan 31, 2008 6:14 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> > Also, with STGT being a pretty new design which has not undergone alot
> > of optimization, perhaps profiling both pieces of code against similar
> > tests would give us a better idea of where userspace bottlenecks reside.
> > Also, the overhead involved with traditional iSCSI for bulk IO from
> > kernel / userspace would also be a key concern for a much larger set of
> > users, as iSER and SRP on IB is a pretty small userbase and will
> > probably remain small for the near future.
> 
> Two important trends in data center technology are server
> consolidation and storage consolidation. A.o. every web hosting
> company can profit from a fast storage solution. I wouldn't call this
> a small user base.
> 
> Regarding iSER and SRP on IB: InfiniBand is today the most economic
> solution for a fast storage network. I do not know which technology
> will be the most popular for storage consolidation within a few years
> -- this can be SRP, iSER, IPoIB + SDP, FCoE (Fibre Channel over
> Ethernet) or maybe yet another technology. No matter which technology
> becomes the most popular for storage applications, there will be a
> need for high-performance storage software.
> 

I meant small referring to storage on IB fabrics which has usually been
in the research and national lab settings, with some other vendors
offering IB as an alternative storage fabric for those who [w,c]ould not
wait for 10 Gb/sec copper Ethernet and Direct Data Placement to come
online.  These types of numbers compared to say traditional iSCSI, that
is getting used all over the place these days in areas I won't bother
listing here.

As for the future, I am obviously cheering for IP storage fabrics, in
particular 10 Gb/sec Ethernet and Direct Data Placement in concert with
iSCSI Extentions for RDMA to give the data center a high performance,
low latency transport that can do OS independent storage multiplexing
and recovery across multiple independently developed implementions.
Also avoiding lock-in from un-interoptable storage transports (espically
on the high end) that had plauged so many vendors in years past has
become an real option in the past few years with a IETF defined block
level storage protocol.  We are actually going on four years since
RFC-3720 was ratified. (April 2004)

Making the 'enterprise' ethernet switching equipment go from millisecond
to nanosecond latency in a whole different story that goes beyond my
area of expertise.  I know there is one startup (Fulcrum Micro) who is
working on this problem and seems to be making some good progress.

--nab

> References:
> * Michael Feldman, Battle of the Network Fabrics, HPCwire, December
> 2006, http://www.hpcwire.com/hpc/1145060.html
> * NetApp, Reducing Data Center Power Consumption Through Efficient
> Storage, February 2007,
> http://www.netapp.com/ftp/wp-reducing-datacenter-power-consumption.pdf
> 
> Bart Van Assche.
> 

