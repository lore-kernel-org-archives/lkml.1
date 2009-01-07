Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbZAGAXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbZAGAXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 19:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZAGAXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 19:23:31 -0500
Received: from mx2.netapp.com ([216.240.18.37]:62309 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbZAGAXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 19:23:30 -0500
X-IronPort-AV: E=Sophos;i="4.37,222,1231142400"; 
   d="scan'208";a="108977616"
Subject: Re: [RFC][PATCH 2/4] sunrpc: Use utsnamespaces
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-nfs@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chuck Lever <chuck.lever@oracle.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Cedric Le Goater <clg@fr.ibm.com>
In-Reply-To: <20090107002024.GJ13785@fieldses.org>
References: <20090106011314.534653345@us.ibm.com>
	 <20090106011314.961946803@us.ibm.com> <20090106200229.GA17031@us.ibm.com>
	 <1231274682.20316.65.camel@heimdal.trondhjem.org>
	 <20090106215831.GE18147@us.ibm.com>
	 <1231281732.4173.6.camel@heimdal.trondhjem.org>
	 <1231286930.14345.196.camel@localhost>
	 <20090107002024.GJ13785@fieldses.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Tue, 06 Jan 2009 19:23:11 -0500
Message-Id: <1231287791.11487.4.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
X-OriginalArrivalTime: 07 Jan 2009 00:23:29.0207 (UTC) FILETIME=[2A15AC70:01C9705E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 19:20 -0500, J. Bruce Fields wrote:
> If it would be possible, for example, for the 'init' namespace to have
> no network interfaces at all, then it would be nicer to use a name
> that's at least been used with nfs at *some* point--just on the general
> principle of not leaking information to a domain that the user wouldn't
> expect it to.

Then RPC would fail. Thanks to the limitations imposed by selinux &
friends, all RPC sockets have to be owned by the init process.
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
