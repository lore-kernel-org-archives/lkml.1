Return-Path: <linux-kernel-owner+w=401wt.eu-S934415AbXFFBUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934415AbXFFBUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 21:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933752AbXFFBUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 21:20:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50806 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933190AbXFFBUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 21:20:08 -0400
Date: Tue, 5 Jun 2007 18:20:08 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: clameter@sgi.com, akpm@linux-foundation.org, ak@suse.de,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
Message-Id: <20070605182008.102c3fe9.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.99.0706051813070.23799@chino.kir.corp.google.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
	<20070605160149.348b5c4a.pj@sgi.com>
	<alpine.DEB.0.99.0706051608090.16201@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0706051619130.6192@schroedinger.engr.sgi.com>
	<alpine.DEB.0.99.0706051620580.17032@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0706051629270.6295@schroedinger.engr.sgi.com>
	<alpine.DEB.0.99.0706051633590.17626@chino.kir.corp.google.com>
	<20070605165538.0a3ce6fe.pj@sgi.com>
	<alpine.DEB.0.99.0706051813070.23799@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure, that behavior is unchanged.  We're relying on 
> nearest_exclusive_ancestor() to determine if such nodes overlap.

Ok ... my points on cpusets semantics having been heard,
I stand back down on the matter of memory semantics, where
I am not the master.

Thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
