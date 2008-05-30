Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYE3ScB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYE3ScB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 14:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYE3Sbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 14:31:51 -0400
Received: from mx2.netapp.com ([216.240.18.37]:3456 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbYE3Sbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 14:31:50 -0400
X-IronPort-AV: E=Sophos;i="4.27,568,1204531200"; 
   d="scan'208";a="78879924"
Subject: Re: NFS oops in 2.6.26rc4
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Dave Jones <davej@redhat.com>
Cc: chucklever@gmail.com, Chuck Lever <chuck.lever@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080530182126.GB32480@redhat.com>
References: <20080527190419.GA14577@redhat.com>
	 <76bd70e30805301059v461e8f0eocc38b6fe36dd3b21@mail.gmail.com>
	 <20080530182126.GB32480@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Fri, 30 May 2008 11:31:48 -0700
Message-Id: <1212172308.8579.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
X-OriginalArrivalTime: 30 May 2008 18:31:48.0839 (UTC) FILETIME=[6BFE4770:01C8C283]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-30 at 14:21 -0400, Dave Jones wrote:

> mount point in the fstab is ..
> 
> gelk:/mnt/data      /mnt/nfs/gelk       nfs     nfsvers=3,tcp        0 0
> 
>  >  What "brand" of server were you trying to mount?
> 
> It's just another linux box. A no-name core2 duo, running 2.6.25.
> 
>  > How often can you reproduce this?
> 
> Seems to do it every time I ask it to.

Could you provide us with a binary tcpdump in that case? I'd love to
have a look at the actual filehandle the server is producing.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
