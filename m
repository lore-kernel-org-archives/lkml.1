Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbYDBOul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbYDBOul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbYDBOuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:50:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753343AbYDBOuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:50:32 -0400
Date: Wed, 2 Apr 2008 07:50:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc8
In-Reply-To: <18418.44094.156352.405647@cargo.ozlabs.ibm.com>
Message-ID: <alpine.LFD.1.00.0804020748100.14670@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0804011257310.14670@woody.linux-foundation.org> <18418.44094.156352.405647@cargo.ozlabs.ibm.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Apr 2008, Paul Mackerras wrote:
> Linus Torvalds writes:
> 
> > I think the dirstat continues to be fairly informative, with arch/ and 
> > drivers dominating as usual. And within arch, a fair amount of the line 
> > noise are all those defconfigs. I wish we had some saner way of handling 
> > that
> 
> We (the arch maintainers) could try to do the bulk of the defconfig
> updates at about -rc2 or -rc3 time, if you'd prefer.

Well, that part isn't the one that I think is bothersome - I just wonder 
if the whole "defconfig" mess is worth keeping with the kernel at _all_.

It also causes tons of noise whenever I happen to do something like "git 
grep CONFIG_XYZZY" to see where some config variable is used etc.

So I was more wondering whether maybe there could be better ways of doing 
that whole thing. 

		Linus
