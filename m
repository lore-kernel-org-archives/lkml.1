Return-Path: <linux-kernel-owner+w=401wt.eu-S1756951AbZAGAix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbZAGAix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 19:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZAGAio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 19:38:44 -0500
Received: from mx2.netapp.com ([216.240.18.37]:32490 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbZAGAim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 19:38:42 -0500
X-IronPort-AV: E=Sophos;i="4.37,222,1231142400"; 
   d="scan'208";a="108981567"
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
In-Reply-To: <20090107002608.GK13785@fieldses.org>
References: <20090106011314.534653345@us.ibm.com>
	 <20090106011314.961946803@us.ibm.com> <20090106200229.GA17031@us.ibm.com>
	 <1231274682.20316.65.camel@heimdal.trondhjem.org>
	 <20090106215831.GE18147@us.ibm.com> <m1eizg11fy.fsf@frodo.ebiederm.org>
	 <1231283734.8041.6.camel@heimdal.trondhjem.org>
	 <20090106233238.GD13785@fieldses.org>
	 <1231284943.8041.8.camel@heimdal.trondhjem.org>
	 <1231287607.11487.0.camel@heimdal.trondhjem.org>
	 <20090107002608.GK13785@fieldses.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Tue, 06 Jan 2009 19:38:26 -0500
Message-Id: <1231288706.11487.15.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-OriginalArrivalTime: 07 Jan 2009 00:38:41.0730 (UTC) FILETIME=[49FDA220:01C97060]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 19:26 -0500, J. Bruce Fields wrote:
> On Tue, Jan 06, 2009 at 07:20:07PM -0500, Trond Myklebust wrote:
> > As for the NFSv4 clientid, I can't see how you would ever want to use
> > anything other than the init->utsname(), since the requirement is only
> > that the clientid string be unique and preserved across reboots. The
> > server isn't allowed to interpret the contents of the clientid string.
> > Ditto for the RPCSEC_GSS machine creds that are used to establish the
> > clientid.
> 
> If people eventually expect to be able to, say, migrate a container to
> another host while using an nfs mount as their storage, then they'd need
> the name to be that of the container, not of the host.

Why?

> Obviously we'd also need to ensure the container got its own nfsv4
> client state, etc., etc., and it sounds like we're far from that.

Again, why? Are you seriously proposing a plan to transport all NFS and
locking state directly from one kernel to another?

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
