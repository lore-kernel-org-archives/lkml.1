Return-Path: <linux-kernel-owner+w=401wt.eu-S1753332AbZEOSae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbZEOSae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbZEOS3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:29:25 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:54349 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756297AbZEOS3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:29:24 -0400
Date: Fri, 15 May 2009 13:58:30 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
In-Reply-To: <alpine.DEB.2.00.0905141459370.624@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0905151358070.26559@qirst.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com> <alpine.DEB.1.10.0905121708470.14226@qirst.com> <20090514092909.GG1365@ucw.cz> <alpine.DEB.1.10.0905141546040.1381@qirst.com>
 <1242333519.15391.210.camel@nimitz> <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz> <alpine.DEB.1.10.0905141729180.30187@qirst.com> <1242337042.28440.34.camel@nimitz>
 <alpine.DEB.2.00.0905141459370.624@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, David Rientjes wrote:

> > To me it at least adds the fact that more should be made *available* and
> > not just that you're out of it.  So, definitely not perfect, but better
> > than "out".
> >
>
> I think "no allowable memory" followed by information on what is and is
> not allowed in that specific context would remove any ambiguity.

Useful information to have. If a NUMA or cgroup restriction caused the
failure then we should print that out.

