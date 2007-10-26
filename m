Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbXJZSrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbXJZSrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 14:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbXJZSq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 14:46:57 -0400
Received: from smtp-out.google.com ([216.239.33.17]:55129 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbXJZSq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 14:46:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=cgmc912gZCw8HWEeinZZlH2MlSqFiLrPYWu9klWiNxzk2QEs8VVy+4QH5b7r7Ki/o
	YBeUpCmEYe6BA0BYdE1tw==
Date: Fri, 26 Oct 2007 11:46:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <1193412644.5032.13.camel@localhost>
Message-ID: <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>  <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>  <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>  <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
  <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>  <20071025185506.8c373aa8.pj@sgi.com>  <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com> <1193412644.5032.13.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Lee Schermerhorn wrote:

> Actually, my patch doesn't change the set_mempolicy() API at all, it
> just co-opts a currently unused/illegal value for the nodemask to
> indicate "all allowed nodes".  Again, I need to provide a libnuma API to
> request this.   Soon come, mon...
> 

If something that was previously unaccepted is now allowed with a 
newly-introduced semantic, that's an API change.
