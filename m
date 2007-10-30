Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbXJ3XRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbXJ3XRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbXJ3XRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:17:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46866 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752993AbXJ3XRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:17:31 -0400
Date: Tue, 30 Oct 2007 16:17:28 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071030161728.40f27300.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710301548350.15640@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
	<1193434278.5032.106.camel@localhost>
	<alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
	<20071026180713.aeedfac2.pj@sgi.com>
	<Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
	<20071026194144.6042316a.pj@sgi.com>
	<alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com>
	<20071027161955.e9d4d2db.pj@sgi.com>
	<alpine.DEB.0.9999.0710272231170.23796@chino.kir.corp.google.com>
	<20071028164637.8d1b45b0.pj@sgi.com>
	<alpine.DEB.0.9999.0710281742090.26837@chino.kir.corp.google.com>
	<20071028212745.57a7db67.pj@sgi.com>
	<alpine.DEB.0.9999.0710282130320.32474@chino.kir.corp.google.com>
	<20071028224533.df924291.pj@sgi.com>
	<alpine.DEB.0.9999.0710282352270.23978@chino.kir.corp.google.com>
	<20071029002602.34866d8c.pj@sgi.com>
	<alpine.DEB.0.9999.0710301548350.15640@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> The nodemask passed to set_mempolicy() will always have exactly one
> meaning: the system nodes that the policy is intended for.

Ok - that makes the meaning of Choice C clearer to me.  Thank-you.

We've already got two Choices, one released and one in the oven.  Is
there an actual, real world situation, motivating this third Choice?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
