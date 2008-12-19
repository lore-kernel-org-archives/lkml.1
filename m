Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbYLSLof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbYLSLof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 06:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYLSLo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 06:44:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36681 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbYLSLo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 06:44:26 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20081219041401.GA29316@us.ibm.com>
References: <20081219041401.GA29316@us.ibm.com> <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144145.10667.39594.stgit@warthog.procyon.org.uk>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: dhowells@redhat.com, trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/45] Create a dynamically sized pool of threads for doing very slow work items [ver #41]
Date: Fri, 19 Dec 2008 11:44:21 +0000
Message-ID: <10451.1229687061@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn <serue@us.ibm.com> wrote:

> > +	set_user_nice(current, -5);
> 
> Just curious - why -5?

Actually, that's entirely arbitrary.  I should probably make it configurable.

> Whenever it is actually running you'd like it to have slightly higher
> priority than ordinary user tasks?

It's normally performing I/O on behalf of other tasks.  I'm not sure what the
best way to prioritise it is.

David
