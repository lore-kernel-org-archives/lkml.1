Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbYDKP0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbYDKP0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759823AbYDKP0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:26:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759251AbYDKP0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:26:04 -0400
Date: Fri, 11 Apr 2008 08:25:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, Dave Jones <davej@redhat.com>,
       drepper@redhat.com, mingo@redhat.com, tglx@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: [PATCH] Fix compile breakage caused by asmlinkage_protect
In-Reply-To: <20080411151156.GJ9785@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.1.00.0804110821400.3143@woody.linux-foundation.org>
References: <alpine.LFD.1.00.0804101447240.3143@woody.linux-foundation.org> <20080410223738.80A8326F992@magilla.localdomain> <20080411114654.GA12270@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.00.0804110744100.3143@woody.linux-foundation.org>
 <20080411151156.GJ9785@ZenIV.linux.org.uk>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Apr 2008, Al Viro wrote:
> 
> and that gets us -traditional-cpp passed to cc1, with obvious resulting
> unhappiness from vararg macro.

Yeah, I figured it out eventually. 

I do think the architectures should try to avoid it, if only because x86 
doesn't use -traditional (so they'll hit things like this unnecessarily 
otherwise), but I'll apply Heiko's minimal patch in the meantime.

		Linus
