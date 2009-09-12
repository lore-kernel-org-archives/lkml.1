Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbZILF1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbZILF1Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 01:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbZILF1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 01:27:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:50963 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbZILF1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 01:27:23 -0400
Date: Sat, 12 Sep 2009 07:30:38 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, jakub@redhat.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       x86@kernel.org
Subject: Re: [PATCH 1/2] UNREACHABLE() macro
Message-ID: <20090912073038.01eecacf@infradead.org>
In-Reply-To: <4AAB26FE.7010309@kernel.org>
References: <20090910015923.8FB628AE5F@magilla.sf.frob.com>
	<20090910020031.87DC68BF6E@magilla.sf.frob.com>
	<20090911134528.cd1782d9.akpm@linux-foundation.org>
	<20090911215525.12B366A98F@magilla.sf.frob.com>
	<20090912054906.22b05848@infradead.org>
	<4AAB26FE.7010309@kernel.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009 21:43:42 -0700
"H. Peter Anvin" <hpa@kernel.org> wrote:

> On 09/11/2009 08:49 PM, Arjan van de Ven wrote:
> > On Fri, 11 Sep 2009 14:55:25 -0700 (PDT)
> > Roland McGrath <roland@redhat.com> wrote:
> > 
> >>> That's a bit of a mouthful.  Did you consider a runtime probe with
> >>> scripts/Kbuild.include's try-run, cc-option, etc?  
> >>
> >> I did not see any precedent in the sources for using those to test
> >> for features by compiling particular test sources (i.e. in autoconf
> > 
> > look at the stackprotector flags.. they work this way already.
> > It gets done once per kernel build...
> > 
> 
> That works for flags, but not for the presence of builtin functions.
> You can't even just try compiling something, since it will turn into
> an ordinary function if not present... not obvious until link.

"-DGG_HAS_UNREACHABLE" is a compiler flag ;-)
and the shell script can just do a "nm" on the resulting .o file to
detect if it turned into a function call... entirely possible.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
