Return-Path: <linux-kernel-owner+w=401wt.eu-S1754672AbZJOOTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbZJOOTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 10:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbZJOOTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 10:19:11 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:41924 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZJOOTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 10:19:10 -0400
Date: Thu, 15 Oct 2009 09:18:22 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: mtk.manpages@gmail.com
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH v2] define convenient securebits masks for prctl users
Message-ID: <20091015141822.GB16162@us.ibm.com>
References: <20091014211542.GA25218@us.ibm.com> <cfd18e0f0910142226r59f3331fld435840dc96ea334@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cfd18e0f0910142226r59f3331fld435840dc96ea334@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michael Kerrisk (mtk.manpages@googlemail.com):
> Hi Serge,
> 
> On Wed, Oct 14, 2009 at 11:15 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> > The securebits are used by passing them to prctl with the
> > PR_{S,G}ET_SECUREBITS commands.  But the defines must be
> > shifted to be used in prctl, which begs to be confused and
> > misused by userspace.  So define some more convenient
> > values for userspace to specify.  This way userspace does
> >
> >        prctl(PR_SET_SECUREBITS, SECBIT_NOROOT);
> >
> > instead of
> >
> >        prctl(PR_SET_SECUREBITS, 1 << SECURE_NOROOT);
> >
> > Thanks to Michael for the idea.
> >
> > This patch also adds include/linux/securebits to the installed headers.
> > Then perhaps it can be included by glibc's sys/prctl.h.
> >
> > Changelog:
> >        Oct 14: (Suggestions by Michael Kerrisk):
> >                1. spell out SETUID in SECBIT_NO_SETUID*
> >                2. SECBIT_X_LOCKED does not imply SECBIT_X
> >                3. add definitions for keepcaps
> 
> Thanks for these changes.

Thanks for taking a look and commenting!

> >        Oct 14: As suggested by Michael Kerrisk, don't
> >                use SB_* as that convention is already in
> >                use.  Use SECBIT_ prefix instead.
> >
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > Acked-by: Andrew G. Morgan <morgan@kernel.org>
> 
> Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>

thanks,
-serge
