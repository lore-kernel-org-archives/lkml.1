Return-Path: <linux-kernel-owner+w=401wt.eu-S1763592AbYBPAL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763592AbYBPAL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 19:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758331AbYBPALT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 19:11:19 -0500
Received: from relay1.sgi.com ([192.48.171.29]:36635 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758232AbYBPALS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 19:11:18 -0500
Date: Fri, 15 Feb 2008 18:11:14 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
Message-Id: <20080215181114.e4fb0839.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802151548060.30015@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
	<20080214040918.d735e920.pj@sgi.com>
	<alpine.DEB.1.00.0802141336590.6067@chino.kir.corp.google.com>
	<20080215032748.8b07e5eb.pj@sgi.com>
	<alpine.DEB.1.00.0802151216330.19332@chino.kir.corp.google.com>
	<20080215174554.92f14bac.pj@sgi.com>
	<alpine.DEB.1.00.0802151548060.30015@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you know when the patch that adds 
> bitmap_onto(), which is a name I think I noticed you liking, will be 
> available?

Thanks in good part to your various questions regarding it, I realized
a significant error in the central piece of code in that patch, the
routine lib/bitmap.c:bitmap_onto().  I should be done in a few hours
reworking it, and will post it then.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
