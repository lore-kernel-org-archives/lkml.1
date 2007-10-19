Return-Path: <linux-kernel-owner+w=401wt.eu-S933756AbXJSSbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756AbXJSSbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758804AbXJSSbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:31:06 -0400
Received: from smtpout2.l-3com.com ([128.170.207.214]:3153 "EHLO
	smtpout2.L-3com.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094AbXJSSbF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:31:05 -0400
X-IronPort-AV: E=Sophos;i="4.21,301,1188799200"; 
   d="scan'208";a="92023755"
From: Jason.V.Mock@L-3Com.com
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [NFS] Kernel Oops in NFS
Date: Fri, 19 Oct 2007 13:30:57 -0500
Message-ID: <F31FEAB987B7C2469181758C14265CFA040BBB86@gvlexch03.is.l-3com.com>
In-Reply-To: <1192749866.7437.57.camel@heimdal.trondhjem.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [NFS] Kernel Oops in NFS
Thread-Index: AcgR3eTJ3X/w4lbvREu9UZ/V38z5RAAn+q1Q
References: <F31FEAB987B7C2469181758C14265CFA040BBB64@gvlexch03.is.l-3com.com> <F31FEAB987B7C2469181758C14265CFA040BBB7A@gvlexch03.is.l-3com.com> <1192749866.7437.57.camel@heimdal.trondhjem.org>
To: "Trond Myklebust" <trond.myklebust@fys.uio.no>
Cc: <linux-kernel@vger.kernel.org>,
       "Kile, SE Scott @ IS" <scott.kile@L-3Com.com>,
       <nfs@lists.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Trond Myklebust [mailto:trond.myklebust@fys.uio.no] 
> Sent: Thursday, October 18, 2007 18:24
> To: Mock, JV Jason @ IS
> Cc: nfs@lists.sourceforge.net; linux-kernel@vger.kernel.org; 
> Kile, SE Scott @ IS
> Subject: Re: [NFS] Kernel Oops in NFS
> 
> 
> On Thu, 2007-10-18 at 16:01 -0500, Jason.V.Mock@L-3Com.com wrote:
> > > We've come across an Oops, in what appears to NFS.
> > > 
> > > 2.6.22.6 vanilla + realtime-lsm
> > > RHEL4 over PXE/NFS_ROOT
...
> > > [<c01a9fb8>] nfs_lookup+0x11b/0x26a SS:ESP 0068:f63b5d4
> > > 
> > > We haven't seen any negative side-effects other than users seeing 
> > > this in Kwrited quite often.  We've yet to update to 2.6.22.9, 
> > > however we've examined the change logs and patches 
> associated with 
> > > NFS between then and now, and don't see anything 
> appropriate for the 
> > > errors we're receiving.  Let me know if you need anything 
> else for 
> > > this...
> > 
> > I was just checking to see if there's anything that I'm 
> missing here, 
> > in regards to never hearing a single thing back about this.
> > 
> > - Jason Mock
> 
> Well... Your Oops did have the 'tainted' flag set, but in 
> this case I believe that the issue is already known. Please try
> 
>   
> http://client.linux-nfs.org/Linux-2.6.x/2.6.22/linux-2.6.22-01
> 0-fix_nfs_reval_fsid.dif
> 
> Trond
> 

Thanks Trond.  The Tainted flag is *probably* due to the NVIDIA driver,
but I'd also have to check the realtime-lsm.  Either way we'll get that
built up and see...

Thanks again!!

- Jason Mock
