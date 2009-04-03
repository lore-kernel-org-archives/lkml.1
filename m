Return-Path: <linux-kernel-owner+w=401wt.eu-S934210AbZDCRXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934210AbZDCRXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933849AbZDCRXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:23:10 -0400
Received: from sbc-mgw1.sbcounty.gov ([170.164.50.70]:21838 "EHLO
	sbc-mgw1.sbcounty.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933695AbZDCRXJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:23:09 -0400
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Apr 2009 13:23:08 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [Scst-devel] ISCSI-SCST performance (with also IET and STGTdata)
Date: Fri, 3 Apr 2009 10:13:35 -0700
Message-ID: <C2F174F99918D54CA2A96E57C5079B6F012A9649@sbc-exmsg2.sbcounty.gov>
In-Reply-To: <e2e108260904031008u434e6d06rc7d657a087e64fbc@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Scst-devel] ISCSI-SCST performance (with also IET and STGTdata)
Thread-Index: Acm0fu0fycBtOzJJSc6L3E0ZSg5VhwAAG+sg
From: "Sufficool, Stanley" <ssufficool@rov.sbcounty.gov>
To: "Bart Van Assche" <bart.vanassche@gmail.com>,
       "Vladislav Bolkhovitin" <vst@vlnb.net>
Cc: "scst-devel" <scst-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>
X-OriginalArrivalTime: 03 Apr 2009 17:13:36.0831 (UTC) FILETIME=[8691ACF0:01C9B47F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Bart Van Assche [mailto:bart.vanassche@gmail.com] 
> Sent: Friday, April 03, 2009 10:09 AM
> To: Vladislav Bolkhovitin
> Cc: scst-devel; linux-kernel@vger.kernel.org; 
> linux-scsi@vger.kernel.org
> Subject: Re: [Scst-devel] ISCSI-SCST performance (with also 
> IET and STGTdata)
> 
> 
> On Thu, Apr 2, 2009 at 7:16 PM, Vladislav Bolkhovitin 
> <vst@vlnb.net> wrote:
> > Bart Van Assche, on 04/02/2009 12:14 AM wrote:
> >> I have repeated some of these performance tests for iSCSI 
> over IPoIB 
> >> (two DDR PCIe 1.0 ConnectX HCA's connected back to back). 
> The results 
> >> for the buffered I/O test with a block size of 512K (initiator) 
> >> against a file of 1GB residing on a tmpfs filesystem on the target 
> >> are as follows:
> >>
> >> write-test: iSCSI-SCST 243 MB/s; IET 192 MB/s.
> >> read-test: iSCSI-SCST 291 MB/s; IET 223 MB/s.
> >>
> >> And for a block size of 4 KB:
> >>
> >> write-test: iSCSI-SCST 43 MB/s; IET 42 MB/s.
> >> read-test: iSCSI-SCST 288 MB/s; IET 221 MB/s.
> >
> > Do you have any thoughts why writes are so bad? It shouldn't be so..
> 
> It's not impossible that with the 4 KB write test I hit the 
> limits of the initiator system (Intel E6750 CPU, 2.66 GHz, 
> two cores). Some statistics I gathered during the 4 KB write test:
> Target: CPU load 0.5, 16500 mlx4-comp-0 interrupts per 
> second, same number of interrupts processed by each core (8250/s).
> Initiator: CPU load 1.0, 32850 mlx4-comp-0 interrupts per 
> second, all interrupts occurred on the same core.

Are you using connected mode IPoIB and setting the MTU to 4KB? Would
fragmentation of IPoIB drive up the interrupt rates?

> 
> Bart.
> 
> --------------------------------------------------------------
> ----------------
> _______________________________________________
> Scst-devel mailing list
> Scst-devel@lists.sourceforge.net 
> https://lists.sourceforge.net/lists/listinfo/scst-devel
> 
