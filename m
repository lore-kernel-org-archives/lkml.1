Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbYLSSMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbYLSSMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 13:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYLSSMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 13:12:41 -0500
Received: from mx2.netapp.com ([216.240.18.37]:41810 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbYLSSMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 13:12:40 -0500
X-IronPort-AV: E=Sophos;i="4.36,250,1228118400"; 
   d="scan'208";a="100825813"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Pull request for FS-Cache, including NFS patches
Date: Fri, 19 Dec 2008 10:08:45 -0800
Message-ID: <7A24DF798E223B4C9864E8F92E8C93EC01AAF504@SACMVEXC1-PRD.hq.netapp.com>
In-Reply-To: <10926.1229692846@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Pull request for FS-Cache, including NFS patches
Thread-Index: Aclh3KE7CEOnmZ8dT3SIL4cmlcCKoAAJaJfQ
From: "Muntz, Daniel" <Dan.Muntz@netapp.com>
To: "David Howells" <dhowells@redhat.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, <sfr@canb.auug.org.au>,
       <linux-kernel@vger.kernel.org>, <nfsv4@linux-nfs.org>,
       <steved@redhat.com>, <linux-fsdevel@vger.kernel.org>,
       <rwheeler@redhat.com>
X-OriginalArrivalTime: 19 Dec 2008 18:09:36.0125 (UTC) FILETIME=[F37D82D0:01C96204]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AFS was designed to support local disk cache, so with callbacks you can
get a consistent system.  I'll ass-u-me that Linux flavors of AFS have
callbacks.  It should be possible to *integrate* NFSv4.x with FS-Cache
similarly (i.e., I don't think you could drop it in as a 'black-box'
without breaking something, unless you explicitly build an independent
proxy cache server).

  -Dan

-----Original Message-----
From: David Howells [mailto:dhowells@redhat.com] 
Sent: Friday, December 19, 2008 5:21 AM
To: Muntz, Daniel
Cc: dhowells@redhat.com; Andrew Morton; sfr@canb.auug.org.au;
linux-kernel@vger.kernel.org; nfsv4@linux-nfs.org; steved@redhat.com;
linux-fsdevel@vger.kernel.org; rwheeler@redhat.com
Subject: Re: Pull request for FS-Cache, including NFS patches

Muntz, Daniel <Dan.Muntz@netapp.com> wrote:

> Number 3 scares me.  How does this play with the expected semantics of
NFS?

I don't know.  Yet it's something you want to do for AFS, I think.


David
