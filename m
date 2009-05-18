Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbZERX32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbZERX32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 19:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZERX3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 19:29:21 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:60565 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbZERX3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 19:29:20 -0400
Date: Mon, 18 May 2009 23:45:24 +0800
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Pavel Machek <pavel@ucw.cz>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       San Mehat <san@android.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Misleading OOM messages
Message-ID: <20090518154524.GH5156@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1242333519.15391.210.camel@nimitz> <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz> <alpine.DEB.1.10.0905141729180.30187@qirst.com> <20090514213403.GB14741@elf.ucw.cz> <alpine.DEB.1.10.0905151346550.26559@qirst.com> <1242411307.28257.25.camel@nimitz> <alpine.DEB.1.10.0905151526170.13433@qirst.com> <20090515203122.GM4451@balbir.in.ibm.com> <alpine.DEB.1.10.0905181033230.6018@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0905181033230.6018@qirst.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter <cl@linux-foundation.org> [2009-05-18 10:34:22]:

> On Sat, 16 May 2009, Balbir Singh wrote:
> 
> > > But that is a resource control isssue. Should also not say out of memory
> > > but state that the cgroup memory limit was reached.
> > >
> >
> > But we are out of memory for the cgroup under consideration.
> 
> Not necessarily. This only occurs if the cgroup cannot swap or if
> allocations are done that are not swappable.
>

Isn't that the equivalent of out of memory for the system? What would
you like the OOM message to state? 

-- 
	Balbir
