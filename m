Return-Path: <linux-kernel-owner+w=401wt.eu-S1761336AbZDIRvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761336AbZDIRvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 13:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935886AbZDIRuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 13:50:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48914 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935884AbZDIRut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 13:50:49 -0400
Date: Thu, 9 Apr 2009 18:50:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org,
       linux-am33-list@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] MN10300: Move to arch/mn10300/include/asm/
Message-ID: <20090409175029.GC26366@ZenIV.linux.org.uk>
References: <20090409171447.3119.48356.stgit@warthog.procyon.org.uk> <alpine.LFD.2.00.0904091028080.4583@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904091028080.4583@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 10:30:06AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 9 Apr 2009, David Howells wrote:
> >
> > Move arch headers from include/asm-mn10300/ to arch/mn10300/include/asm/.
> 
> This patch looks broken.
> 
> It doesn't "move" anything at all. It just copies things, and leaves the 
> old files alone.
> 
> I wonder if you created the diff by doing
> 
> 	git diff arch/mn10300
> 
> because you had other changes pending that you didn't want to include?
> 
> Regardless, I'm not applying something this obviously broken.

BTW, *please* use -M when posting that kind of patches.  You'll end up with
several lines per moved file and "yes, this is just a move" immediately
obvious from the patch.
