Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbZAGAUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbZAGAUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 19:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbZAGAU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 19:20:29 -0500
Received: from mx2.netapp.com ([216.240.18.37]:50162 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbZAGAU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 19:20:28 -0500
X-IronPort-AV: E=Sophos;i="4.37,222,1231142400"; 
   d="scan'208";a="108976941"
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
In-Reply-To: <20090106235322.GE13785@fieldses.org>
References: <20090106011314.534653345@us.ibm.com>
	 <20090106011314.961946803@us.ibm.com> <20090106200229.GA17031@us.ibm.com>
	 <1231274682.20316.65.camel@heimdal.trondhjem.org>
	 <20090106215831.GE18147@us.ibm.com> <m1eizg11fy.fsf@frodo.ebiederm.org>
	 <1231283734.8041.6.camel@heimdal.trondhjem.org>
	 <20090106233238.GD13785@fieldses.org>
	 <1231284943.8041.8.camel@heimdal.trondhjem.org>
	 <20090106235322.GE13785@fieldses.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Tue, 06 Jan 2009 19:20:12 -0500
Message-Id: <1231287612.11487.1.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-OriginalArrivalTime: 07 Jan 2009 00:20:26.0886 (UTC) FILETIME=[BD69B260:01C9705D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 18:53 -0500, J. Bruce Fields wrote:
> It seems like overkill, though.  Does anyone actually care whether these
> names are right?

I very much doubt it. Particularly since the actual sockets used by the
RPC client are always owned by the init namespace (they are established
from a workqueue process), and so the source IP address will always be
that of the init namespace.

Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
