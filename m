Return-Path: <linux-kernel-owner+w=401wt.eu-S1760561AbXJZRjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760561AbXJZRjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbXJZRjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:39:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52594 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752692AbXJZRje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:39:34 -0400
Date: Fri, 26 Oct 2007 10:39:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: rientjes@google.com, akpm@linux-foundation.org, ak@suse.de,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] cpusets: add memory_spread_user option
In-Reply-To: <20071026101805.df3ebfda.pj@sgi.com>
Message-ID: <Pine.LNX.4.64.0710261038250.15270@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.9999.0710251912300.30400@chino.kir.corp.google.com>
 <alpine.DEB.0.9999.0710251913130.30400@chino.kir.corp.google.com>
 <alpine.DEB.0.9999.0710251913350.30400@chino.kir.corp.google.com>
 <20071025230409.81f20ed3.pj@sgi.com> <alpine.DEB.0.9999.0710260204590.8261@chino.kir.corp.google.com>
 <20071026025634.0f32e1e2.pj@sgi.com> <20071026101805.df3ebfda.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Paul Jackson wrote:

> For example, if they pass in a mask with all bits sets, then they
> get interleave over all the nodes in their current cpuset, even as
> that cpuset changes.  If they pass in a mask with say just two
> bits set, then they will get interleave over just two nodes anytime
> they are in a cpuset with two or more nodes (when in a single node
> cpuset, they will of course get no interleave, for lack of anything
> to interleave over.)

Yuck. I really want cpuset relative nodemasks. Nodes need to reference
to available nodes. If you set all of them then it will use all available 
nodes and ignore the ones not allowed. If you just set the first two bits 
then it will use the first and second node of a cpuset.
