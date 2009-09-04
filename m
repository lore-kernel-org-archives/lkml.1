Return-Path: <linux-kernel-owner+w=401wt.eu-S934381AbZIDWMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934381AbZIDWMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 18:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934369AbZIDWMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 18:12:23 -0400
Received: from mx2.netapp.com ([216.240.18.37]:47097 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934349AbZIDWMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 18:12:22 -0400
X-IronPort-AV: E=Sophos;i="4.44,335,1249282800"; 
   d="scan'208";a="238035616"
Subject: Re: mount.nfs oops [was: mmotm 2009-09-03-16-35 uploaded]
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org
In-Reply-To: <4AA17E74.8060100@gmail.com>
References: <200909032340.n83Ne6E6004708@imap1.linux-foundation.org>
	 <4AA17E74.8060100@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Fri, 04 Sep 2009 18:12:17 -0400
Message-Id: <1252102337.5274.4.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 04 Sep 2009 22:12:18.0262 (UTC) FILETIME=[C4308760:01CA2DAC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-04 at 22:54 +0200, Jiri Slaby wrote:
> On 09/04/2009 01:40 AM, akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-09-03-16-35 has been uploaded to
> 
> Hi, I got an oops while mounting an nfs:
> BUG: unable to handle kernel NULL pointer dereference at 000000000000001d
> IP: [<ffffffffa003924f>] rpcauth_lookupcred+0x4f/0xc0 [sunrpc]

This looks like the auth->au_ops->lookup_cred() call failing due to a
faulty pointer, which should be impossible.

I note that you had a kernel taint due to a warning before this Oops
happened. Any details?

Also, were you doing anything special at the time (for instance removing
a module)?

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
