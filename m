Return-Path: <linux-kernel-owner+w=401wt.eu-S1763742AbXJZVQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763742AbXJZVQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765949AbXJZVQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:16:12 -0400
Received: from smtp-out.google.com ([216.239.45.13]:16132 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765930AbXJZVQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:16:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=BxI6ikOl6QBzaDbyuosvoNIpa5WThGSpobJQGJluLYtZWzn59frxnDuAS1szgCIN0
	vROgOCYqkDUiIImD8qQww==
Date: Fri, 26 Oct 2007 14:15:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <clameter@sgi.com>
cc: Paul Jackson <pj@sgi.com>, Lee.Schermerhorn@hp.com,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <Pine.LNX.4.64.0710261409420.18055@schroedinger.engr.sgi.com>
Message-ID: <alpine.DEB.0.9999.0710261413420.11594@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com> <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com> <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com> <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com> <20071025185506.8c373aa8.pj@sgi.com> <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com> <1193412644.5032.13.camel@localhost> <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
 <20071026120037.7b95a136.pj@sgi.com> <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com> <Pine.LNX.4.64.0710261357370.17483@schroedinger.engr.sgi.com> <alpine.DEB.0.9999.0710261406330.10620@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0710261409420.18055@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Christoph Lameter wrote:

> We would need two fields in the policy structure
> 
> 1. The specified nodemask (generally ignored)
> 

What I've called pol->passed_nodemask.

> 2. The effective nodemask (specified & cpuset_mems_allowed)
> 

Which is pol->v.nodes.

> If we have these two then its easy to get a bit further by making
> the first nodemask a relative nodemask. The calculation of the effective
> nodemask changes somewhat but the logic is then applicable to MPOL_BIND as 
> well.
> 

Agreed.
