Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbYB1InZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbYB1InZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 03:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbYB1InL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 03:43:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbYB1InK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 03:43:10 -0500
Date: Thu, 28 Feb 2008 03:42:37 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Jan Hubicka <hubicka@ucw.cz>
Cc: David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
       Matthew Wilcox <matthew@wil.cx>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, gcc@gcc.gnu.org,
       zadeck@naturalbridge.com
Subject: Re: [PATCH] linux/fs.h - Convert debug functions declared inline  __attribute__((format (printf,x,y) to statement expression macros
Message-ID: <20080228084237.GU24887@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <1204081722.19319.405.camel@localhost> <1204084947.19319.411.camel@localhost> <20080227041316.GA23188@parisc-linux.org> <alpine.DEB.1.00.0802262140160.23764@chino.kir.corp.google.com> <1204095249.19319.444.camel@localhost> <alpine.DEB.1.00.0802271454430.3836@chino.kir.corp.google.com> <20080227235835.GA31048@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227235835.GA31048@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 12:58:35AM +0100, Jan Hubicka wrote:
> We probably also can simply allow inlining variadic functions not
> calling va_start.  I must say that this option appeared to me but I was
> unable to think of any sane use case.  This probably is one ;)

We already allow inlining variadic functions not calling va_start, already
3.2.x did that and so do all following gccs.  In 4.3+
__builtin_va_arg_pack{,_len} support was added, so that you can even pass
the ... arguments to variable length functions, query their count etc.

	Jakub
