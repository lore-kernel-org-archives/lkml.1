Return-Path: <linux-kernel-owner+w=401wt.eu-S1762166AbZCaRh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762166AbZCaRh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 13:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbZCaRhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 13:37:11 -0400
Received: from smtp-out.google.com ([216.239.45.13]:22898 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982AbZCaRhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 13:37:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=jIskWb35kJurJFY2rNz8Gh0sJ0MxbbxZxPA1ApBZ1aSPCdpnDwIHb5/BN61Q/rpLZ
	VO6IMRREUKkIKkuBbXCqw==
Date: Tue, 31 Mar 2009 10:35:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] slub: add per-cache slab thrash ratio
In-Reply-To: <alpine.DEB.1.10.0903311323040.1912@qirst.com>
Message-ID: <alpine.DEB.2.00.0903311031580.12348@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com> <alpine.DEB.1.10.0903301026580.13333@qirst.com> <alpine.DEB.2.00.0903301309010.21074@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0903301718080.25929@qirst.com> <alpine.DEB.2.00.0903301545200.30928@chino.kir.corp.google.com> <alpine.DEB.2.00.0903302140250.27065@chino.kir.corp.google.com> <alpine.DEB.1.10.0903310925130.24040@qirst.com>
 <alpine.DEB.2.00.0903311014140.10407@chino.kir.corp.google.com> <alpine.DEB.1.10.0903311323040.1912@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009, Christoph Lameter wrote:

> > I'd agree that it should be cleared if the tunable had object units
> > instead of a ratio, but the ratio simply applies to any given order.
> 
> Right but resetting the order usually has a significant impact on the
> threashing behavior (if it exists). Why would we keep the threshing ratio
> that was calculated for another slab configuration?
> 

Either the default thrashing ratio is being used and is unchanged from 
boot time in which case it will still apply to the new order, or the ratio 
has already been changed and userspace is responsible for tuning it again 
as the result of the new slab size.
