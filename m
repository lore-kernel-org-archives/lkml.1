Return-Path: <linux-kernel-owner+w=401wt.eu-S1751392AbZGSTst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbZGSTst (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 15:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbZGSTsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 15:48:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbZGSTsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 15:48:46 -0400
Date: Sun, 19 Jul 2009 12:47:25 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Athanasius <link@miggy.org>
cc: linux-kernel <linux-kernel@vger.kernel.org>, Julien TINNES <jt@cr0.org>,
       Greg KH <gregkh@suse.de>, Tavis Ormandy <taviso@sdf.lonestar.org>,
       Christoph Hellwig <hch@infradead.org>, Kees Cook <kees@ubuntu.com>,
       Eugene Teo <eugene@redhat.com>
Subject: Re: [link@miggy.org: Re: [patch 2/8] personality: fix PER_CLEAR_ON_SETID
 (CVE-2009-1895)]
In-Reply-To: <20090719193917.GK6722@miggy.org>
Message-ID: <alpine.LFD.2.01.0907191241460.13838@localhost.localdomain>
References: <20090718202512.GA19587@suse.de> <alpine.LFD.2.01.0907181342500.13838@localhost.localdomain> <20090718212812.GI6722@miggy.org> <4A6278FD.20807@cr0.org> <20090719122701.GJ6722@miggy.org> <alpine.LFD.2.01.0907191219230.13838@localhost.localdomain>
 <20090719193917.GK6722@miggy.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 19 Jul 2009, Athanasius wrote:
> 
>   Would you agree that having these features default-off would be best?

I'm actually pretty sure that some glibc versions in particular have 
actively used some of the personality bits.

I have this fairly clear memory of seeing 'personality()' system calls in 
strace output from regular programs.

I just tested it, and I'm not seeing it in my current distro for normal 
programs, but the point is, I'm pretty sure that we have real binaries out 
there that depend on personality bits.

So we can't default-off the whole personality thing. We would have to 
default-off just a subset of the bits. Would that be useful? Perhaps.

			Linus
