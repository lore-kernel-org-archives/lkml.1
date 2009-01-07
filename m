Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbZAGApQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbZAGApQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 19:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZAGApB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 19:45:01 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbZAGApA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 19:45:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: David Brownell <david-b@pacbell.net>
X-Fcc: ~/Mail/linus
X-Fcc: ~/Mail/linus
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.28-rc2] CORE_DUMP_DEFAULT_ELF_HEADERS depends on ELF_CORE
In-Reply-To: David Brownell's message of  Tuesday, 6 January 2009 12:37:00 -0800 <200901061237.01020.david-b@pacbell.net>
References: <200810301559.50467.david-b@pacbell.net>
	<200901061237.01020.david-b@pacbell.net>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090107004447.3FD19FC305@magilla.sf.frob.com>
Date: Tue,  6 Jan 2009 16:44:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>

> On Thursday 30 October 2008, David Brownell wrote:
> > From: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > Kernels that don't support ELF coredumps at all surely can't
> > be supporting new partial-segment flavored ELF coredumps ...
> > don't make folk answer Kconfig questions about that flavor.
> 
> PING?
> 
> > 
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > Cc: Roland McGrath <roland@redhat.com>
> > ---
> >  fs/Kconfig.binfmt |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- a/fs/Kconfig.binfmt
> > +++ b/fs/Kconfig.binfmt
> > @@ -43,7 +43,7 @@ config BINFMT_ELF_FDPIC
> >  config CORE_DUMP_DEFAULT_ELF_HEADERS
> >  	bool "Write ELF core dumps with partial segments"
> >  	default n
> > -	depends on BINFMT_ELF
> > +	depends on BINFMT_ELF && ELF_CORE
> >  	help
> >  	  ELF core dump files describe each memory mapping of the crashed
> >  	  process, and can contain or omit the memory contents of each one.
> > 
> 
> 
