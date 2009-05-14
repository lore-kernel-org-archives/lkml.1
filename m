Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZENWA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZENWA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbZENWAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:00:15 -0400
Received: from smtp-out.google.com ([216.239.33.17]:10455 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbZENWAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:00:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=DwD+Mff1X7KrzG2Wn7Hnkkb2W1qtjuThAZpwBPSWJPAUFmaYamIxTGvONMP5bbUDt
	5PnKwuZcDARnf4sHzJyGw==
Date: Thu, 14 May 2009 15:00:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Christoph Lameter <cl@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
In-Reply-To: <1242337042.28440.34.camel@nimitz>
Message-ID: <alpine.DEB.2.00.0905141459370.624@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com> <alpine.DEB.1.10.0905121708470.14226@qirst.com> <20090514092909.GG1365@ucw.cz> <alpine.DEB.1.10.0905141546040.1381@qirst.com>
 <1242333519.15391.210.camel@nimitz> <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz> <alpine.DEB.1.10.0905141729180.30187@qirst.com> <1242337042.28440.34.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009, Dave Hansen wrote:

> > > -	printk(KERN_ERR "%s: kill process %d (%s) score %li or a child\n",
> > > +	printk(KERN_ERR "No available memory %s: "
> > > +			"kill process %d (%s) score %li or a child\n",
> > >  					message, task_pid_nr(p), p->comm, points);
> > 
> > "No available memory" still suggests that plugging in more memory is the
> > right solution.
> 
> To me it at least adds the fact that more should be made *available* and
> not just that you're out of it.  So, definitely not perfect, but better
> than "out".
> 

I think "no allowable memory" followed by information on what is and is 
not allowed in that specific context would remove any ambiguity.
