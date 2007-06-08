Return-Path: <linux-kernel-owner+w=401wt.eu-S968403AbXFHIB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968403AbXFHIB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938559AbXFHH1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:27:09 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:49425 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938488AbXFHH1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:27:07 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 8 Jun 2007 03:25:19 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: William Lee Irwin III <wli@holomorphy.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: why does the macro "ZERO_PAGE" take an argument?
In-Reply-To: <46687598.2040701@zytor.com>
Message-ID: <Pine.LNX.4.64.0706080324280.15839@localhost.localdomain>
References: <Pine.LNX.4.64.0706070715290.14293@localhost.localdomain>
 <4667EC18.4080904@yahoo.com.au> <Pine.LNX.4.64.0706070731250.14994@localhost.localdomain>
 <a781481a0706070439p6dda152l37e475ae0fa698ef@mail.gmail.com>
 <Pine.LNX.4.64.0706070750540.16051@localhost.localdomain> <4668412D.3030506@zytor.com>
 <20070607192911.GV6909@holomorphy.com> <46687598.2040701@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007, H. Peter Anvin wrote:

> William Lee Irwin III wrote:
> > Robert P. J. Day wrote:
> >>> although it's not clear where in the source tree are the invocations
> >>> that would actually make a difference to a MIPS system, which is why
> >>> i've CC'ed ralf on this.  i'm sure he can clear this up. :-)
> >
> > On Thu, Jun 07, 2007 at 10:32:29AM -0700, H. Peter Anvin wrote:
> >> x86 could also benefit from coloured zeropages.  In fact, I thought it
> >> already had them (K8 wants as many as 8.)
> >
> > How would one demonstrate the beneficial effect of such?
>
> Dean Gaudet at Transmeta did some benchmarking using SPEC.  If I
> recall his numbers correctly (this is from memory, mind you) on
> Transmeta Efficeon, which has 2-way virtual cache tagging with
> hardware recovery, zeropage coloring was a 1.5% performance
> improvement.

and once again, an initially innocuous question quickly leaves me
behind.  no, no, i'm getting used to it.  :-P

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
