Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbYLTGF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbYLTGF6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 01:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbYLTGFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 01:05:49 -0500
Received: from mx2.netapp.com ([216.240.18.37]:3622 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbYLTGFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 01:05:48 -0500
X-IronPort-AV: E=Sophos;i="4.36,253,1228118400"; 
   d="scan'208";a="101061253"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Pull request for FS-Cache, including NFS patches
Date: Fri, 19 Dec 2008 22:05:38 -0800
Message-ID: <7A24DF798E223B4C9864E8F92E8C93EC01AAF709@SACMVEXC1-PRD.hq.netapp.com>
In-Reply-To: <13180.1229736005@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Pull request for FS-Cache, including NFS patches
Thread-Index: AcliQSPaPvtPeDn3SJeSfvzUq+HsIQAJ324w
From: "Muntz, Daniel" <Dan.Muntz@netapp.com>
To: "David Howells" <dhowells@redhat.com>,
       "Bryan Henderson" <hbryan@us.ibm.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <nfsv4@linux-nfs.org>, <rwheeler@redhat.com>, <sfr@canb.auug.org.au>,
       <steved@redhat.com>
X-OriginalArrivalTime: 20 Dec 2008 06:05:45.0669 (UTC) FILETIME=[FF559750:01C96268]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
