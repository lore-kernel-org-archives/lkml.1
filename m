Return-Path: <linux-kernel-owner+w=401wt.eu-S1753620AbYLSR6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbYLSR6X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 12:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYLSR6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 12:58:14 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52631 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbYLSR6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 12:58:13 -0500
Date: Fri, 19 Dec 2008 11:58:09 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: trond.myklebust@fys.uio.no, viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/45] Make slow-work thread pool actually dynamic [ver
	#41]
Message-ID: <20081219175809.GA17113@us.ibm.com>
References: <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144150.10667.42993.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120144150.10667.42993.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Make the slow-work thread pool actually dynamic in the number of threads it
> contains.  With this patch, it will both create additional threads when it has
> extra work to do, and cull excess threads that aren't doing anything.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Looks good.

Acked-by: Serge Hallyn <serue@us.ibm.com>
