Return-Path: <linux-kernel-owner+w=401wt.eu-S933407AbXHYNBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407AbXHYNBA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 09:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbXHYNAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 09:00:50 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:36088 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864AbXHYNAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 09:00:50 -0400
Date: Sat, 25 Aug 2007 15:02:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Roland McGrath <roland@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [POWERPC] Fix for assembler -g
Message-ID: <20070825130210.GC15183@uranus.ravnborg.org>
References: <20070820213259.956EB4D05F4@magilla.localdomain> <533f74c072dc11b514fe4dc87fd7edc5@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533f74c072dc11b514fe4dc87fd7edc5@kernel.crashing.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 12:29:08AM +0200, Segher Boessenkool wrote:
> >>But there is no lparmap.o!  lparmap.s is the generated file.
> >
> >Yeah, tell that to scripts/Makefile.lib:
> >
> >	_c_flags       = $(CFLAGS) $(EXTRA_CFLAGS) $(CFLAGS_$(basetarget).o)
> >
> >What would do what a person expects is $(CFLAGS_$(@F)), I think.
> 
> Looks good to me.  Sam?  We wanted to set CFLAGS_lparmap.s .

To avoid confusion (in most cases) setting CFLAGS_file.o
does the expected thing in case on .o, .s, .lst and .i targets.
So the general and easy to remember rule is to set CFLAGS_file.o
and then kbuild takes care of the rest.

I assume you already did so and it solved your problem - no?

	Sam
