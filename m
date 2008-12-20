Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbYLTGG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbYLTGG5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 01:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbYLTGGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 01:06:47 -0500
Received: from mx2.netapp.com ([216.240.18.37]:10634 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbYLTGGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 01:06:47 -0500
X-IronPort-AV: E=Sophos;i="4.36,253,1228118400"; 
   d="scan'208";a="101061554"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Pull request for FS-Cache, including NFS patches
Date: Fri, 19 Dec 2008 22:06:13 -0800
Message-ID: <7A24DF798E223B4C9864E8F92E8C93EC01AAF70A@SACMVEXC1-PRD.hq.netapp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Pull request for FS-Cache, including NFS patches
Thread-Index: AcliQSPaPvtPeDn3SJeSfvzUq+HsIQAJ324wAAAZMoA=
From: "Muntz, Daniel" <Dan.Muntz@netapp.com>
To: "Muntz, Daniel" <Dan.Muntz@netapp.com>,
       "David Howells" <dhowells@redhat.com>,
       "Bryan Henderson" <hbryan@us.ibm.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <nfsv4@linux-nfs.org>, <rwheeler@redhat.com>, <sfr@canb.auug.org.au>,
       <steved@redhat.com>
X-OriginalArrivalTime: 20 Dec 2008 06:06:46.0156 (UTC) FILETIME=[23632CC0:01C96269]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Um.. make that "approximating" :-) 

-----Original Message-----
From: Muntz, Daniel 
Sent: Friday, December 19, 2008 10:06 PM
To: 'David Howells'; Bryan Henderson
Cc: Andrew Morton; linux-fsdevel@vger.kernel.org;
linux-kernel@vger.kernel.org; nfsv4@linux-nfs.org; rwheeler@redhat.com;
sfr@canb.auug.org.au; steved@redhat.com
Subject: RE: Pull request for FS-Cache, including NFS patches

Callbacks, instead of assuming your data is good for some short period
of time.  It's all well and good that there are mechanisms to know that
data has changed, but without some leasing/callback/(ugh)mandatory
locking, you're just estimating consistency.

  -Dan 

-----Original Message-----
From: David Howells [mailto:dhowells@redhat.com]
Sent: Friday, December 19, 2008 5:20 PM
To: Bryan Henderson
Cc: dhowells@redhat.com; Andrew Morton; Muntz, Daniel;
linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org;
nfsv4@linux-nfs.org; rwheeler@redhat.com; sfr@canb.auug.org.au;
steved@redhat.com
Subject: Re: Pull request for FS-Cache, including NFS patches

Bryan Henderson <hbryan@us.ibm.com> wrote:

> > > AFS was designed to support local disk cache, so with callbacks 
> > > you can get a consistent system.
> > 
> > It's less the callbacks and more the data version number that's
important.
> 
> Maybe for consistency, but for the performance benefits of local disk 
> caching, I believe the callbacks are pretty important.

Indeed, but he said "so with callbacks you can get a _consistent_
system".

David
