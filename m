Return-Path: <linux-kernel-owner+w=401wt.eu-S1760291AbYDKPhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291AbYDKPhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758396AbYDKPha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:37:30 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:24556 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYDKPh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:37:29 -0400
Date: Fri, 11 Apr 2008 11:37:28 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, Dave Jones <davej@redhat.com>,
       drepper@redhat.com, mingo@redhat.com, tglx@redhat.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: [PATCH] Fix compile breakage caused by asmlinkage_protect
Message-ID: <20080411153728.GG27073@phobos.i.cabal.ca>
References: <alpine.LFD.1.00.0804101447240.3143@woody.linux-foundation.org> <20080410223738.80A8326F992@magilla.localdomain> <20080411114654.GA12270@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.00.0804110744100.3143@woody.linux-foundation.org> <20080411151156.GJ9785@ZenIV.linux.org.uk> <alpine.LFD.1.00.0804110821400.3143@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0804110821400.3143@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 08:25:05AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 11 Apr 2008, Al Viro wrote:
> > 
> > and that gets us -traditional-cpp passed to cc1, with obvious resulting
> > unhappiness from vararg macro.
> 
> Yeah, I figured it out eventually. 
> 
> I do think the architectures should try to avoid it, if only because x86 
> doesn't use -traditional (so they'll hit things like this unnecessarily 
> otherwise), but I'll apply Heiko's minimal patch in the meantime.
> 

Cool with me; I'll try to puzzle out why removing -traditional breaks on
those two specific files. Ugh, big cleanups likely.

cheers, Kyle
