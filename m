Return-Path: <linux-kernel-owner+w=401wt.eu-S1760928AbYBMDwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760928AbYBMDwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 22:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYBMDwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 22:52:47 -0500
Received: from relay2.sgi.com ([192.48.171.30]:44707 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750787AbYBMDwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 22:52:46 -0500
Date: Tue, 12 Feb 2008 21:52:42 -0600
From: Paul Jackson <pj@sgi.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: rientjes@google.com, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
Message-Id: <20080212215242.0342fa25.pj@sgi.com>
In-Reply-To: <1202862136.4974.41.camel@localhost>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
	<1202862136.4974.41.camel@localhost>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee wrote:
> 1) we've discussed the issue of returning EINVAL for non-empty nodemasks
> with MPOL_DEFAULT.  By removing this restriction, we run the risk of
> breaking applications if we should ever want to define a semantic to
> non-empty node mask for MPOL_DEFAULT. 

The bigger risk, in my view, is breaking some piece of existing user code.
Properly written user code wouldn't break, but that doesn't mean much.
Changes, even minor corner case changes, often break something, so should
not be done with out cause.  Whether or not code cleanup in mempolicy.c is
sufficient cause here is not clear to me.

Future room for growth doesn't mean so much for me here; if we close one
future alternative, we always have others, such as more mode flag bits.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
