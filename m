Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbZENVhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbZENVhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 17:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbZENVha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 17:37:30 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:33158 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbZENVha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 17:37:30 -0400
Subject: Re: Misleading OOM messages
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0905141729180.30187@qirst.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0905121708470.14226@qirst.com>
	 <20090514092909.GG1365@ucw.cz>
	 <alpine.DEB.1.10.0905141546040.1381@qirst.com>
	 <1242333519.15391.210.camel@nimitz>
	 <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com>
	 <1242335120.15391.242.camel@nimitz>
	 <alpine.DEB.1.10.0905141729180.30187@qirst.com>
Content-Type: text/plain
Date: Thu, 14 May 2009 14:37:22 -0700
Message-Id: <1242337042.28440.34.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-14 at 17:30 -0400, Christoph Lameter wrote:
> On Thu, 14 May 2009, Dave Hansen wrote:
> 
> > -	printk(KERN_ERR "%s: kill process %d (%s) score %li or a child\n",
> > +	printk(KERN_ERR "No available memory %s: "
> > +			"kill process %d (%s) score %li or a child\n",
> >  					message, task_pid_nr(p), p->comm, points);
> 
> "No available memory" still suggests that plugging in more memory is the
> right solution.

To me it at least adds the fact that more should be made *available* and
not just that you're out of it.  So, definitely not perfect, but better
than "out".

-- Dave

