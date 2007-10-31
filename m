Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbXJaAF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbXJaAF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbXJaAFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:05:49 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40547 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752066AbXJaAFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:05:48 -0400
Date: Tue, 30 Oct 2007 17:05:45 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071030170545.f16bdae7.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710301618590.19750@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
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
	<20071030161728.40f27300.pj@sgi.com>
	<alpine.DEB.0.9999.0710301618590.19750@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> But, with Choice C, my intent is still preserved in the mempolicy even 
> though it's not effected because my access rights to the node has changed.  

Choice B, as I'm coding it, has this property as well.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
