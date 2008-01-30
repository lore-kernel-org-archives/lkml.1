Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722AbYA3Gqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbYA3Gqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 01:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbYA3Gqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 01:46:39 -0500
Received: from mx2.netapp.com ([216.240.18.37]:37699 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbYA3Gqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 01:46:37 -0500
X-IronPort-AV: E=Sophos;i="4.25,275,1199692800"; 
   d="scan'208";a="147485743"
Subject: Re: [PATCH 24/27] NFS: Use local caching [try #2]
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: David Howells <dhowells@redhat.com>
Cc: chuck.lever@oracle.com, nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <18686.1201663501@redhat.com>
References: <479901A8.3000706@oracle.com>
	 <20080123172038.11107.86025.stgit@warthog.procyon.org.uk>
	 <20080123172246.11107.62216.stgit@warthog.procyon.org.uk>
	 <18686.1201663501@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Wed, 30 Jan 2008 01:46:31 -0500
Message-Id: <1201675591.7246.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 30 Jan 2008 06:46:32.0023 (UTC) FILETIME=[D938D670:01C8630B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-30 at 03:25 +0000, David Howells wrote:
> Chuck Lever <chuck.lever@oracle.com> wrote:
> 
> > This patch really ought to be broken into more manageable atomic
> > changes to make it easier to review, and to provide more fine-grained
> > explanation and rationalization for each specific change via
> > individual patch descriptions.
> 
> Hmmm....  I broke the patch up as Trond stipulated - at least, I thought I
> had.
> 
> In many ways this request doesn't make sense.  You can't do NFS caching
> without all the appropriate bits, so logically they should be one patch.
> Breaking it up won't help git-bisect since the option to enable all this is
> the last (or nearly last) patch.

That depends entirely on what you are tracking. At this point in time,
I'm completely uninterested in debugging cachefs, but _very_ interested
in tracking and debugging changes to core NFS code.

Trond
