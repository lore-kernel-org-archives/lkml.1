Return-Path: <linux-kernel-owner+w=401wt.eu-S1761402AbZAHQzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761402AbZAHQzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 11:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbZAHQza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 11:55:30 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:63486 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbZAHQz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:55:29 -0500
Subject: Re: Increase dirty_ratio and dirty_background_ratio?
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       peterz@infradead.org, jack@suse.cz, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, npiggin@suse.de
In-Reply-To: <alpine.LFD.2.00.0901080842180.3283@localhost.localdomain>
References: <alpine.LFD.2.00.0901070833430.3057@localhost.localdomain>
	 <20090107.125133.214628094.davem@davemloft.net>
	 <20090108030245.e7c8ceaf.akpm@linux-foundation.org>
	 <20090108.082413.156881254.davem@davemloft.net>
	 <alpine.LFD.2.00.0901080842180.3283@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 08 Jan 2009 11:55:01 -0500
Message-Id: <1231433701.14304.24.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.49662FED.0055:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 08:48 -0800, Linus Torvalds wrote:
> 
> On Thu, 8 Jan 2009, David Miller wrote:
> 
> > From: Andrew Morton <akpm@linux-foundation.org>
> > Date: Thu, 8 Jan 2009 03:02:45 -0800
> > 
> > > The kernel can't get this right - it doesn't know the usage
> > > patterns/workloads, etc.
> > 
> > I don't agree with that.
> 
> We can certainly try to tune it better. 
> 

Does it make sense to hook into kupdate?  If kupdate finds it can't meet
the no-data-older-than 30 seconds target, it lowers the sync/async combo
down to some reasonable bottom.  

If it finds it is going to sleep without missing the target, raise the
combo up to some reasonable top.

-chris


