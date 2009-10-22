Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbZJVTRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbZJVTRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 15:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756595AbZJVTRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 15:17:16 -0400
Received: from smtp-out.google.com ([216.239.33.17]:59093 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756656AbZJVTRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 15:17:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=h2lHWPnzdL3EkZ14aigXI9rXhn3+xrWMkdfIQQLR/HbfWgmWPLYt02HaSYHtstksA
	neXfTwUqq9fqiw8NHBGDw==
Date: Thu, 22 Oct 2009 12:17:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Jiri Kosina <jkosina@suse.cz>, Stephan von Krawczynski <skraw@ithnet.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Frans Pop <elendil@planet.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: page allocation failure message kernel 2.6.31.4 (tty-related)
In-Reply-To: <20091022105902.GM11778@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0910221216550.21601@chino.kir.corp.google.com>
References: <20091020153838.665bc39c.skraw@ithnet.com> <alpine.LRH.2.00.0910211848510.20992@twin.jikos.cz> <alpine.DEB.2.00.0910211409390.20010@chino.kir.corp.google.com> <20091022105902.GM11778@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Oct 2009, Mel Gorman wrote:

> From bca71e94e10cd93771ec5b17eccb817dd0c85360 Mon Sep 17 00:00:00 2001
> From: Mel Gorman <mel@csn.ul.ie>
> Date: Thu, 22 Oct 2009 11:55:14 +0100
> Subject: [PATCH] page allocator: Do not allow interrupts to use ALLOC_HARDER
> 
> Commit 341ce06f69abfafa31b9468410a13dbd60e2b237 altered watermark logic
> slightly by allowing rt_tasks that are handling an interrupt to set
> ALLOC_HARDER. This patch brings the watermark logic more in line with
> 2.6.30.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Acked-by: David Rientjes <rientjes@google.com>
