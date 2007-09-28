Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbXI1UZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbXI1UZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 16:25:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbXI1UY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 16:24:56 -0400
Received: from phunq.net ([64.81.85.152]:53286 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750933AbXI1UYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 16:24:55 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: Re: A unresponsive file system can hang all I/O in the system on linux-2.6.23-rc6 (dirty_thresh problem?)
Date: Fri, 28 Sep 2007 13:24:34 -0700
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Chakri n <chakriin5@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com> <20070928122628.965137f2.akpm@linux-foundation.org> <1191009148.6702.46.camel@heimdal.trondhjem.org>
In-Reply-To: <1191009148.6702.46.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281324.35160.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 September 2007 12:52, Trond Myklebust wrote:
> I'm not sure that the hang that is illustrated here is so special. It
> is an example of a bog-standard ext3 write, that ends up calling the
> NFS client, which is hanging. The fact that it happens to be hanging
> on the nfsd process is more or less irrelevant here: the same thing
> could happen to any other process in the case where we have an NFS
> server that is down.

Hi Trond,

Could you clarify what you meant by "calling the NFS client"?  I don't 
see any direct call in the posted backtrace.

Regards,

Daniel
