Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbYCJTK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbYCJTK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 15:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbYCJTKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 15:10:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41955 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752621AbYCJTKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 15:10:15 -0400
Date: Mon, 10 Mar 2008 12:09:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: pj@sgi.com, clameter@sgi.com, Lee.Schermerhorn@hp.com, ak@suse.de,
       randy.dunlap@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm 1/2] mempolicy: disallow static or relative flags
 for local preferred mode
Message-Id: <20080310120902.5f25b9f9.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.00.0803071720460.4611@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0803071720460.4611@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008 17:24:15 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES don't mean anything for
> MPOL_PREFERRED policies that were created with an empty nodemask (for
> purely local allocations).  They'll never be invalidated because the
> allowed mems of a task changes or need to be rebound relative to a
> cpuset's placement.
> 
> Also fixes a bug identified by Lee Schermerhorn that disallowed empty
> nodemasks to be passed to MPOL_PREFERRED to specify local allocations.

I get a significant-looking reject from this.  Can you please redo and
resend?


I put my current rollup (against -rc5) at
http://userweb.kernel.org/~akpm/dr.gz and the broken-out tree is, as always
at http://userweb.kernel.org/~akpm/mmotm/

It would be better for you to get set up for using mmotm - it is my usual
way of publishing the -mm queue between releases.
