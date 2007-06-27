Return-Path: <linux-kernel-owner+w=401wt.eu-S1761965AbXF0RcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761965AbXF0RcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbXF0RcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:32:18 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42343 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752279AbXF0RcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:32:17 -0400
Date: Wed, 27 Jun 2007 19:32:40 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
Cc: mrmacman_g4@mac.com, linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       david@lang.hm
Subject: Userspace compiler support of "long long"
Message-ID: <20070627173240.GR1094@stusta.de>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de> <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm> <467b0bf2.Xfs7T8Ys4nY9ZNLW%Joerg.Schilling@fokus.fraunhofer.de> <1182483527.10524.31.camel@shinybook.infradead.org> <20070622150038.GN23017@stusta.de> <E27BAC4D-2F1E-4191-A75D-4DD18231C320@mac.com> <20070627154046.GN1094@stusta.de> <468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <468287a8.spBb6PdAZ4QV0j2Y%Joerg.Schilling@fokus.fraunhofer.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 05:52:08PM +0200, Joerg Schilling wrote:
> Adrian Bunk <bunk@stusta.de> wrote:
> 
> > That's a good point I missed.
> >
> > What about:
> >
> > #if defined(__GNUC__) && __STDC_VERSION__ < 19901L
> > __extension__ typedef   signed long long __s64;
> > __extension__ typedef unsigned long long __u64;
> > #else
> > typedef   signed long long __s64;
> > typedef unsigned long long __u64;
> > #endif
> 
> What about using:
> 
> #if (defined(__GNUC__) || defined(__SUNPRO_C)) && !defined(__STRICT_ANSI__) 

AFAIR __extension__ was gcc specific.

Does the Sun cc provide options for strict C90 checking?
And if yes, what is it's syntax for disabling this checking for a line 
of code?

> Well, there seems to be one other compiler (the one from Intel).
> It may be that if this compiler does not claim to be GCC, another
> definituion needs to be added.

AFAIR the Intel compiler claims to be gcc.

But these are by far not the only C compilers under Linux, and the more 
important points are:

Is there any userspace Linux compiler that does not support "long long"?
If yes, is there any other way to tell that something is a
64bit int on 32bit architectures?

> Jörg

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

