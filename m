Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbZAGDpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbZAGDpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 22:45:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbZAGDow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 22:44:52 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52754 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbZAGDov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 22:44:51 -0500
Subject: Re: [RFC][PATCH 2/4] sunrpc: Use utsnamespaces
From: Matt Helsley <matthltc@us.ibm.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-nfs@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chuck Lever <chuck.lever@oracle.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Cedric Le Goater <clg@fr.ibm.com>
In-Reply-To: <1231287791.11487.4.camel@heimdal.trondhjem.org>
References: <20090106011314.534653345@us.ibm.com>
	 <20090106011314.961946803@us.ibm.com> <20090106200229.GA17031@us.ibm.com>
	 <1231274682.20316.65.camel@heimdal.trondhjem.org>
	 <20090106215831.GE18147@us.ibm.com>
	 <1231281732.4173.6.camel@heimdal.trondhjem.org>
	 <1231286930.14345.196.camel@localhost>
	 <20090107002024.GJ13785@fieldses.org>
	 <1231287791.11487.4.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 19:44:48 -0800
Message-Id: <1231299888.14345.369.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 19:23 -0500, Trond Myklebust wrote:
> On Tue, 2009-01-06 at 19:20 -0500, J. Bruce Fields wrote:
> > If it would be possible, for example, for the 'init' namespace to have
> > no network interfaces at all, then it would be nicer to use a name
> > that's at least been used with nfs at *some* point--just on the general
> > principle of not leaking information to a domain that the user wouldn't
> > expect it to.
> 
> Then RPC would fail. Thanks to the limitations imposed by selinux &
> friends, all RPC sockets have to be owned by the init process.

Interesting -- I'm not familiar with this requirement of selinux. Must
it be the init process of the initial pid namespace or could any pid
namespace's init process own it?

Cheers,
	-Matt Helsley

