Return-Path: <linux-kernel-owner+w=401wt.eu-S1762139AbXGMDDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762139AbXGMDDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 23:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbXGMDDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 23:03:30 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58557 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbXGMDD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 23:03:29 -0400
Date: Fri, 13 Jul 2007 11:54:46 +0900 (JST)
Message-Id: <20070713.115446.48513196.tshibata@ab.jp.nec.com>
To: rob@landley.net
Cc: LeoLi@freescale.com, gh@us.ibm.com, hpa@zytor.com,
       kunai@linux-foundation.jp, holzheu@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       lf_kernel_messages@linux-foundation.jp.nec.com, tshibata@ab.jp.nec.com
Subject: Re: Documentation of kernel messages (Summary)
From: Tsugikazu Shibata <tshibata@ab.jp.nec.com>
In-Reply-To: <200707121335.55817.rob@landley.net>
References: <989B956029373F45A0B8AF0297081890F05F2F@zch01exm26.fsl.freescale.net>
	<200707121335.55817.rob@landley.net>
X-Mailer: Mew version 4.2 on Emacs 20.7 / Mule 4.1
 =?iso-2022-jp?B?KBskQjAqGyhCKQ==?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007 13:35:54 -0400, rob wrote:
> On Thursday 12 July 2007 9:53:54 am Li Yang-r58472 wrote:
> > > Fielding patches and questions sounds like plenty to me...)
> >
> > I do think the documentation translation is very necessary even when
> > there is a language maintainer, especially for the policy documents as
> > HOWTO, codestyle , and etc.  The contributors should go through these
> > policies and check their code for compliance before going to the
> > language maintainer for help, or there will be too much for the language
> > maintainer to translate.  The language maintainer doesn't need to
> > translate all the documents himself, but he can help to coordinate the
> > translation effort and help to make it update to date.
> 
> It would help if all the policy documents got grouped into a single 
> Documentation/development directory so we could separate "policy documents in 
> each language would be nice" from "that document about the amiga zorro bus 
> really needs to be kept up-to-date in Navajo and that should be in the kernel 
> tarball please".
> 
> Lemme see, which ones are we talking about?  The candidates are:
>   applying-patches.txt
>   BUG-HUNTING
>   Changes
>   CodingStyle
>   debugging-modules.txt
This file seems mostly technical. may not policy related document.

>   feature-removal-schedule.txt
>   HOWTO
>   kernel-docs.txt
>   language-maintainers.txt
>   ManagementStyle
>   oops-tracing.txt
>   SecurityBugs
>   sparse.txt
>   stable_api_nonsense.txt
>   stable_kernel_rules.txt
>   SubmitChecklist
>   SubmittingDrivers
>   SubmittingPatches
>   volatile-considered-harmful.txt

How about adding; 
kernel-doc-nano-HOWTO.txt

These three slightly include some policy in the documents but purpose
are mostly technical. (So, it's just comment)
devices.txt
kernel-parameters.txt
unicode.txt

> That's everything I noticed in the top level directory that's a good candidate 
> to be grouped into a "development" subdirectory.  Did I miss anything?
> 
> I note that Changes is a bit stale in places (16 bit assembly?), 
> feature-removal-schedule.txt changes often but is good to know, 
> kernel-docs.txt might be useless to translate considering it's mostly links 
> to english documentation, language-maintainers.txt is assuming my patch from 
> earlier today gets accepted...
> 
> I can submit a patch grouping all that stuff together into a subdirectory if 
> it would help...
> 
> > If we do need a contact person, I can do it.  However I don't think
> > there will be much translation work to do here.  As I stated before,
> > most Chinese programmers are more or less capable of read/write
> > technical English.  The difficult part is to let them know the benefit
> > of merging code in kernel and teach them how to do it.  That's why the
> > policy documents in native language will be very useful.
> 
> Does the above look like a good list?  There are more that need to be written, 
> but that's what I saw in Documentation...
> 
> Rob
> 
> P.S.  Dear kmail/postfix developers: having a transient DNS lookup failure on 
> one address in a long cc: list is _NOT_ a reason to have the message stay in 
> the kmail outbox.  It should go into the postfix send queue and be retried 
> from there.  Right now, if I tell it to resend, how do I know who it has and 
> hasn't been successfully distributed to on the first attempt?  I've gotten 
> dinged for trimming the cc: list before, but now I'm about to send out 
> duplicates.  Wheee...
