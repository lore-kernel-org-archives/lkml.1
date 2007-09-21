Return-Path: <linux-kernel-owner+w=401wt.eu-S1761202AbXIUQYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761202AbXIUQYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 12:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759482AbXIUQYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 12:24:45 -0400
Received: from mx2.netapp.com ([216.240.18.37]:10810 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757959AbXIUQYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 12:24:44 -0400
X-IronPort-AV: E=Sophos;i="4.20,284,1186383600"; 
   d="scan'208";a="106441794"
Subject: Re: [NFS] NFS on loopback locks up entire system(2.6.23-rc6)?
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Chakri n <chakriin5@gmail.com>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <92cbf19b0709210920p3647788dl11d8c4e0cee1f70f@mail.gmail.com>
References: <92cbf19b0709201722k6265e647x31b7d25bc54b63a0@mail.gmail.com>
	 <1190335423.6763.180.camel@heimdal.trondhjem.org>
	 <92cbf19b0709202012s375c6f54m588987b4bbf552bc@mail.gmail.com>
	 <1190384005.6680.20.camel@heimdal.trondhjem.org>
	 <92cbf19b0709210920p3647788dl11d8c4e0cee1f70f@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Fri, 21 Sep 2007 12:24:41 -0400
Message-Id: <1190391881.6680.73.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 21 Sep 2007 16:24:42.0584 (UTC) FILETIME=[EA4B1D80:01C7FC6B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 09:20 -0700, Chakri n wrote:
> Thanks.
> 
> I was using flock (BSD locking) and I think the problem should be
> solved if I move my application to use POSIX locks.

Yup.

> And any option to avoid processes waiting indefinitely to free pages
> from NFS requests waiting on unresponsive NFS server?

The only solution I know of is to use soft mounts, but that brings
another set of problems:
     1. most applications don't know how to recover safely from an EIO
        error.
     2. You lose data.

Cheers
  Trond
