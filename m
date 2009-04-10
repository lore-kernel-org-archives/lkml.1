Return-Path: <linux-kernel-owner+w=401wt.eu-S1761443AbZDJBQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443AbZDJBQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 21:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbZDJBQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 21:16:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754383AbZDJBQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 21:16:08 -0400
Date: Thu, 9 Apr 2009 18:13:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Howells <dhowells@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] FRV: Move to arch/frv/include/asm/
In-Reply-To: <15445.1239325609@redhat.com>
Message-ID: <alpine.LFD.2.00.0904091811250.4583@localhost.localdomain>
References: <alpine.LFD.2.00.0904091645010.4583@localhost.localdomain> <alpine.LFD.2.00.0904091628580.4583@localhost.localdomain> <20090409232152.13220.28141.stgit@warthog.procyon.org.uk> <20090409232157.13220.63863.stgit@warthog.procyon.org.uk>
 <13476.1239320297@redhat.com> <15445.1239325609@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Apr 2009, David Howells wrote:
>
> Running 'git show' in the remote repository, and that shows the patches I've
> committed on the master branch as expected, as does 'git log'.
> 
> Is this due to the web server taking its time to register the changes to the
> git repositories?  git-ls-remote says:

Yes, I suspect you _just_ pushed the changes to master, and then when 
pull-request tries to validate it, they just haven't yet mirrored out, so 
the validation fails.

The delay usually is on the order of a few minutes, so it's actually nice 
to wait - because that way, if I happen to be reading email and do the 
pull immediately, it all works for me too.

		Linus
