Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbZAGBu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbZAGBu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 20:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbZAGBuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 20:50:46 -0500
Received: from mx2.netapp.com ([216.240.18.37]:9668 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbZAGBup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 20:50:45 -0500
X-IronPort-AV: E=Sophos;i="4.37,222,1231142400"; 
   d="scan'208";a="109005602"
Subject: Re: [RFC][PATCH 2/4] sunrpc: Use utsnamespaces
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Matt Helsley <matthltc@us.ibm.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-nfs@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chuck Lever <chuck.lever@oracle.com>,
       Linux Containers <containers@lists.osdl.org>,
       Cedric Le Goater <clg@fr.ibm.com>
In-Reply-To: <20090107014422.GA17913@fieldses.org>
References: <20090106200229.GA17031@us.ibm.com>
	 <1231274682.20316.65.camel@heimdal.trondhjem.org>
	 <20090106215831.GE18147@us.ibm.com> <m1eizg11fy.fsf@frodo.ebiederm.org>
	 <1231283734.8041.6.camel@heimdal.trondhjem.org>
	 <20090106233238.GD13785@fieldses.org>
	 <1231284943.8041.8.camel@heimdal.trondhjem.org>
	 <1231287607.11487.0.camel@heimdal.trondhjem.org>
	 <20090107002608.GK13785@fieldses.org>
	 <1231288706.11487.15.camel@heimdal.trondhjem.org>
	 <20090107014422.GA17913@fieldses.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Tue, 06 Jan 2009 20:50:25 -0500
Message-Id: <1231293025.11487.43.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-OriginalArrivalTime: 07 Jan 2009 01:50:44.0631 (UTC) FILETIME=[5AA3FA70:01C9706A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 20:44 -0500, J. Bruce Fields wrote:
> > Again, why? Are you seriously proposing a plan to transport all NFS and
> > locking state directly from one kernel to another?
> 
> If people seem to think they can do live process and container
> migration:
> 
> 	http://ols.fedoraproject.org/OLS/Reprints-2008/mirkin-reprint.pdf
> 
> then moving the NFS state strikes me as not the greatest of their
> troubles.

ROTFL...


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
