Return-Path: <linux-kernel-owner+w=401wt.eu-S1762153AbZFXTsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762153AbZFXTsB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 15:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbZFXTrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 15:47:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751428AbZFXTrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 15:47:52 -0400
Date: Wed, 24 Jun 2009 12:47:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: penberg@cs.helsinki.fi, arjan@infradead.org, linux-kernel@vger.kernel.org,
       cl@linux-foundation.org, npiggin@suse.de
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
In-Reply-To: <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906241246380.3154@localhost.localdomain>
References: <20090624080753.4f677847@infradead.org> <20090624094622.d0b0fd82.akpm@linux-foundation.org> <84144f020906240955h5e26a248scc61439c1ca36023@mail.gmail.com> <20090624105517.904f93da.akpm@linux-foundation.org> <4A426825.80905@cs.helsinki.fi>
 <20090624113037.7d72ed59.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241134510.3240@localhost.localdomain> <20090624120617.1e6799b5.akpm@linux-foundation.org> <alpine.LFD.2.01.0906241211550.3154@localhost.localdomain> <20090624123624.26c93459.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0906241240360.3154@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Jun 2009, Linus Torvalds wrote:
> 
> Your point?
> 
> That's the recursive allocation or oom case. Not the normal case at all.

In fact, as the whole comment explains, that case is the "give people 
memory _now_, even if we normally wouldn't". The thing is, we can't 
recurse into trying to free memory, because we're already in that path.

		Linus
