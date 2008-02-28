Return-Path: <linux-kernel-owner+w=401wt.eu-S1758974AbYB1KXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758974AbYB1KXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 05:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbYB1KX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 05:23:27 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:43603 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbYB1KX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 05:23:27 -0500
Date: Thu, 28 Feb 2008 11:23:25 +0100
From: Jan Hubicka <hubicka@ucw.cz>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Jan Hubicka <hubicka@ucw.cz>, David Rientjes <rientjes@google.com>,
       Joe Perches <joe@perches.com>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, gcc@gcc.gnu.org,
       zadeck@naturalbridge.com
Subject: Re: [PATCH] linux/fs.h - Convert debug functions declared inline  __attribute__((format (printf,x,y) to statement expression macros
Message-ID: <20080228102325.GC13246@atrey.karlin.mff.cuni.cz>
References: <1204081722.19319.405.camel@localhost> <1204084947.19319.411.camel@localhost> <20080227041316.GA23188@parisc-linux.org> <alpine.DEB.1.00.0802262140160.23764@chino.kir.corp.google.com> <1204095249.19319.444.camel@localhost> <alpine.DEB.1.00.0802271454430.3836@chino.kir.corp.google.com> <20080227235835.GA31048@atrey.karlin.mff.cuni.cz> <20080228084237.GU24887@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228084237.GU24887@devserv.devel.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Feb 28, 2008 at 12:58:35AM +0100, Jan Hubicka wrote:
> > We probably also can simply allow inlining variadic functions not
> > calling va_start.  I must say that this option appeared to me but I was
> > unable to think of any sane use case.  This probably is one ;)
> 
> We already allow inlining variadic functions not calling va_start, already
> 3.2.x did that and so do all following gccs.  In 4.3+
> __builtin_va_arg_pack{,_len} support was added, so that you can even pass
> the ... arguments to variable length functions, query their count etc.

Hmm, I now remember this change. Thanks for pointing it out ;) I guess
it is just more or less random difference then (ie different ordering of
hashtables). The difference is tiny anyway.  The call ought to be always
early inlined and not seen by any optimization pass.

Honza
> 
> 	Jakub
