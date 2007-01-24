Return-Path: <linux-kernel-owner+w=401wt.eu-S1752039AbXAXUlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbXAXUlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 15:41:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbXAXUlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 15:41:14 -0500
Received: from mx2.netapp.com ([216.240.18.37]:29623 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbXAXUlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 15:41:13 -0500
X-IronPort-AV: i="4.13,233,1167638400"; 
   d="scan'208"; a="24980621:sNHT14675444"
Subject: Re: [NFS] [PATCH 3/3] NFS: Ensure we support selinux xattrs
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Andrew Morton <akpm@osdl.org>,
       Jim Meyering <meyering@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, James Morris <jmorris@namei.org>,
       nfs@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.64.0701241228050.3606@woody.linux-foundation.org>
References: <20070124195307.21259.64156.stgit@lade.trondhjem.org>
	 <20070124195457.21259.53047.stgit@lade.trondhjem.org>
	 <1169669288.15390.155.camel@moss-spartans.epoch.ncsc.mil>
	 <Pine.LNX.4.64.0701241228050.3606@woody.linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Wed, 24 Jan 2007 12:40:03 -0800
Message-Id: <1169671203.6280.26.camel@lade.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
X-OriginalArrivalTime: 24 Jan 2007 20:42:02.0220 (UTC) FILETIME=[19E49AC0:01C73FF8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 12:29 -0800, Linus Torvalds wrote:
> 
> On Wed, 24 Jan 2007, Stephen Smalley wrote:
> > 
> > I don't think you want to just set the incore inode security state on
> > the client side, as that won't be preserved.
> 
> I agree. The fix seems much worse than the problem.
> 
> It doesn't seem to be a kernel bug (except insofar that you can argue that 
> enabling ACL's at all is a bug), and it also doesn't look like a 
> regression.

Fair enough. Please drop this patch then.

Trond
