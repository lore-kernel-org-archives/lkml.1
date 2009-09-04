Return-Path: <linux-kernel-owner+w=401wt.eu-S934370AbZIDWxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934370AbZIDWxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 18:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934441AbZIDWxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 18:53:43 -0400
Received: from mx2.netapp.com ([216.240.18.37]:51257 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934427AbZIDWxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 18:53:42 -0400
X-IronPort-AV: E=Sophos;i="4.44,335,1249282800"; 
   d="scan'208";a="238049331"
Subject: Re: mount.nfs oops [was: mmotm 2009-09-03-16-35 uploaded]
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org
In-Reply-To: <4AA19420.5060503@gmail.com>
References: <200909032340.n83Ne6E6004708@imap1.linux-foundation.org>
	 <4AA17E74.8060100@gmail.com>
	 <1252102337.5274.4.camel@heimdal.trondhjem.org>
	 <4AA19420.5060503@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Fri, 04 Sep 2009 18:53:17 -0400
Message-Id: <1252104797.5274.19.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 04 Sep 2009 22:53:44.0321 (UTC) FILETIME=[8DFF0710:01CA2DB2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-09-05 at 00:26 +0200, Jiri Slaby wrote:
> On 09/05/2009 12:12 AM, Trond Myklebust wrote:
> > Also, were you doing anything special at the time (for instance removing
> > a module)?
> 
> Not at all. I just did
> # mount /work
> # grep work /etc/fstab
> XXX.YYY.ZZZ:/work     /work           nfs     defaults,intr   0 0
> 
> Thanks.

Hmm... Is it fully reproducible? I'm running the same NFS client code
(although not the full linux-mm) on several different client platforms
without seeing any issues.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
