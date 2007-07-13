Return-Path: <linux-kernel-owner+w=401wt.eu-S1761338AbXGMRMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761338AbXGMRMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 13:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbXGMRMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 13:12:32 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:35087
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751843AbXGMRMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 13:12:31 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
Subject: Re: Documentation of kernel messages (Summary)
Date: Fri, 13 Jul 2007 13:12:27 -0400
User-Agent: KMail/1.9.6
Cc: LeoLi@freescale.com, gh@us.ibm.com, hpa@zytor.com,
       kunai@linux-foundation.jp, holzheu@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       lf_kernel_messages@linux-foundation.jp.nec.com
References: <989B956029373F45A0B8AF0297081890F05F2F@zch01exm26.fsl.freescale.net> <200707121335.55817.rob@landley.net> <20070713.115446.48513196.tshibata@ab.jp.nec.com>
In-Reply-To: <20070713.115446.48513196.tshibata@ab.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707131312.28004.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 July 2007 10:54:46 pm Tsugikazu Shibata wrote:
> On Thu, 12 Jul 2007 13:35:54 -0400, rob wrote:
> > On Thursday 12 July 2007 9:53:54 am Li Yang-r58472 wrote:
> > > > Fielding patches and questions sounds like plenty to me...)
> > >
> > > I do think the documentation translation is very necessary even when
> > > there is a language maintainer, especially for the policy documents as
> > > HOWTO, codestyle , and etc.  The contributors should go through these
> > > policies and check their code for compliance before going to the
> > > language maintainer for help, or there will be too much for the
> > > language maintainer to translate.  The language maintainer doesn't need
> > > to translate all the documents himself, but he can help to coordinate
> > > the translation effort and help to make it update to date.
> >
> > It would help if all the policy documents got grouped into a single
> > Documentation/development directory so we could separate "policy
> > documents in each language would be nice" from "that document about the
> > amiga zorro bus really needs to be kept up-to-date in Navajo and that
> > should be in the kernel tarball please".
> >
> > Lemme see, which ones are we talking about?  The candidates are:
> >   applying-patches.txt
> >   BUG-HUNTING
> >   Changes
> >   CodingStyle
> >   debugging-modules.txt
>
> This file seems mostly technical. may not policy related document.

Yeah, I guess so.  My mental filter was actually more like "how to do linux 
development", and it seemed both short and easy to translate, and also 
generally relevant to the majority of developers no matter what subsystem 
they're working on.

But I agree, it's not policy.

> >   feature-removal-schedule.txt
> >   HOWTO
> >   kernel-docs.txt
> >   language-maintainers.txt
> >   ManagementStyle
> >   oops-tracing.txt
> >   SecurityBugs
> >   sparse.txt

That one's not policy either, but it is general non-subsystem-specific 
development.  Probably "applying-patches.txt" above goes in the same bucket.

Whether or not to include that bucket in the new directory depends on whether 
the directory is labeled "development" or "policy" or something else...

> >   stable_api_nonsense.txt
> >   stable_kernel_rules.txt
> >   SubmitChecklist
> >   SubmittingDrivers
> >   SubmittingPatches
> >   volatile-considered-harmful.txt
>
> How about adding;
> kernel-doc-nano-HOWTO.txt

The problem is, the generated htmdocs are in english.  This file is about how 
to generate (and author) English documentation that won't be translated.  
What's the point of translating the instructions if the result won't be 
translated?

On the other hand, if the authors of patches _do_ put javadoc comments into 
the source code, the language maintainer should be aware of them and should 
have some easy way to translate them for the list...

> These three slightly include some policy in the documents but purpose
> are mostly technical. (So, it's just comment)
> devices.txt
> kernel-parameters.txt
> unicode.txt

Extracting the policy out into separate documents I could see, but I agree 
those are primarily technical.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
