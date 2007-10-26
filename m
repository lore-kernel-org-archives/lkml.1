Return-Path: <linux-kernel-owner+w=401wt.eu-S1762608AbXJZRnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762608AbXJZRnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbXJZRnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:43:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52792 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754055AbXJZRnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:43:08 -0400
Date: Fri, 26 Oct 2007 10:43:06 -0700
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: rientjes@google.com, akpm@linux-foundation.org, ak@suse.de,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] cpusets: add memory_spread_user option
Message-Id: <20071026104306.38f6f6ba.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710261038250.15270@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.9999.0710251912300.30400@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251913130.30400@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251913350.30400@chino.kir.corp.google.com>
	<20071025230409.81f20ed3.pj@sgi.com>
	<alpine.DEB.0.9999.0710260204590.8261@chino.kir.corp.google.com>
	<20071026025634.0f32e1e2.pj@sgi.com>
	<20071026101805.df3ebfda.pj@sgi.com>
	<Pine.LNX.4.64.0710261038250.15270@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I really want cpuset relative nodemasks. Nodes need to reference
> to available nodes. If you set all of them then it will use all available 
> nodes and ignore the ones not allowed. If you just set the first two bits 
> then it will use the first and second node of a cpuset.

Exactly.  I think I am ending up with exactly this.

I'm just getting there by a strange way of thinking
(as usual ;).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
