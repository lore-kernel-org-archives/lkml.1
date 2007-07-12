Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbXGLR6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbXGLR6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 13:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbXGLR62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 13:58:28 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:33021
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754796AbXGLR60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 13:58:26 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "Li Yang-r58472" <LeoLi@freescale.com>
Subject: Re: Documentation of kernel messages (Summary)
Date: Thu, 12 Jul 2007 13:35:54 -0400
User-Agent: KMail/1.9.6
Cc: "Gerrit Huizenga" <gh@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, tim.bird@am.sony.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, joe@perches.com,
       auke-jan.h.kok@intel.com, hansendc@us.ibm.com, davem@davemloft.net,
       Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, linux-doc@vger.kernel.org
References: <989B956029373F45A0B8AF0297081890F05F2F@zch01exm26.fsl.freescale.net>
In-Reply-To: <989B956029373F45A0B8AF0297081890F05F2F@zch01exm26.fsl.freescale.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707121335.55817.rob@landley.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 July 2007 9:53:54 am Li Yang-r58472 wrote:
> > Fielding patches and questions sounds like plenty to me...)
>
> I do think the documentation translation is very necessary even when
> there is a language maintainer, especially for the policy documents as
> HOWTO, codestyle , and etc.  The contributors should go through these
> policies and check their code for compliance before going to the
> language maintainer for help, or there will be too much for the language
> maintainer to translate.  The language maintainer doesn't need to
> translate all the documents himself, but he can help to coordinate the
> translation effort and help to make it update to date.

It would help if all the policy documents got grouped into a single 
Documentation/development directory so we could separate "policy documents in 
each language would be nice" from "that document about the amiga zorro bus 
really needs to be kept up-to-date in Navajo and that should be in the kernel 
tarball please".

Lemme see, which ones are we talking about?  The candidates are:
  applying-patches.txt
  BUG-HUNTING
  Changes
  CodingStyle
  debugging-modules.txt
  feature-removal-schedule.txt
  HOWTO
  kernel-docs.txt
  language-maintainers.txt
  ManagementStyle
  oops-tracing.txt
  SecurityBugs
  sparse.txt
  stable_api_nonsense.txt
  stable_kernel_rules.txt
  SubmitChecklist
  SubmittingDrivers
  SubmittingPatches
  volatile-considered-harmful.txt

That's everything I noticed in the top level directory that's a good candidate 
to be grouped into a "development" subdirectory.  Did I miss anything?

I note that Changes is a bit stale in places (16 bit assembly?), 
feature-removal-schedule.txt changes often but is good to know, 
kernel-docs.txt might be useless to translate considering it's mostly links 
to english documentation, language-maintainers.txt is assuming my patch from 
earlier today gets accepted...

I can submit a patch grouping all that stuff together into a subdirectory if 
it would help...

> If we do need a contact person, I can do it.  However I don't think
> there will be much translation work to do here.  As I stated before,
> most Chinese programmers are more or less capable of read/write
> technical English.  The difficult part is to let them know the benefit
> of merging code in kernel and teach them how to do it.  That's why the
> policy documents in native language will be very useful.

Does the above look like a good list?  There are more that need to be written, 
but that's what I saw in Documentation...

Rob

P.S.  Dear kmail/postfix developers: having a transient DNS lookup failure on 
one address in a long cc: list is _NOT_ a reason to have the message stay in 
the kmail outbox.  It should go into the postfix send queue and be retried 
from there.  Right now, if I tell it to resend, how do I know who it has and 
hasn't been successfully distributed to on the first attempt?  I've gotten 
dinged for trimming the cc: list before, but now I'm about to send out 
duplicates.  Wheee...
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
