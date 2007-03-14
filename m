Return-Path: <linux-kernel-owner+w=401wt.eu-S1161209AbXCNMfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161209AbXCNMfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 08:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161223AbXCNMfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 08:35:37 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:59719 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161209AbXCNMfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 08:35:36 -0400
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
	Take 2
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <glommer@gmail.com>
In-Reply-To: <p73slc8863r.fsf@bingen.suse.de>
References: <20070314050819.536207642@goodmis.org>
	 <p73slc8863r.fsf@bingen.suse.de>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 08:35:08 -0400
Message-Id: <1173875708.31159.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 11:36 +0100, Andi Kleen wrote:
> Steven Rostedt <rostedt@goodmis.org> writes:
> > 
> > So I spent last night hacking up something to try to make a common ground
> > for all code that is shared between x86_64 and i386.  I called this
> > 
> >    arch/x86
> 
> NACK. I think the current ways work just fine. 

Fine.

The thing is others and I (and you) are working on getting paravirt_ops
working for x86_64.  There's a lot of overlap between i386 and x86_64.
Right now the i386 is ahead of x86_64 and the code seems to be put more
in the arch/i386 arch.  So now we are going to introduce a
new ../../i386 hack to get to a shared paravirt_shared.c(?).  Or do we
just continue on keeping the x86_64 as a separate entity, with a lot of
duplicate code?

I'm OK with either way. I just wanted to set a standard while it's still
early enough to set one.

-- Steve


