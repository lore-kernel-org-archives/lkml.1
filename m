Return-Path: <linux-kernel-owner+w=401wt.eu-S936902AbXFGVWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936902AbXFGVWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758791AbXFGVWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:22:34 -0400
Received: from terminus.zytor.com ([192.83.249.54]:48198 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbXFGVWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:22:34 -0400
Message-ID: <46687598.2040701@zytor.com>
Date: Thu, 07 Jun 2007 14:16:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: "Robert P. J. Day" <rpjday@mindspring.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: why does the macro "ZERO_PAGE" take an argument?
References: <Pine.LNX.4.64.0706070715290.14293@localhost.localdomain> <4667EC18.4080904@yahoo.com.au> <Pine.LNX.4.64.0706070731250.14994@localhost.localdomain> <a781481a0706070439p6dda152l37e475ae0fa698ef@mail.gmail.com> <Pine.LNX.4.64.0706070750540.16051@localhost.localdomain> <4668412D.3030506@zytor.com> <20070607192911.GV6909@holomorphy.com>
In-Reply-To: <20070607192911.GV6909@holomorphy.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> Robert P. J. Day wrote:
>>> although it's not clear where in the source tree are the invocations
>>> that would actually make a difference to a MIPS system, which is why
>>> i've CC'ed ralf on this.  i'm sure he can clear this up. :-)
> 
> On Thu, Jun 07, 2007 at 10:32:29AM -0700, H. Peter Anvin wrote:
>> x86 could also benefit from coloured zeropages.  In fact, I thought it
>> already had them (K8 wants as many as 8.)
> 
> How would one demonstrate the beneficial effect of such?

Dean Gaudet at Transmeta did some benchmarking using SPEC.  If I recall
his numbers correctly (this is from memory, mind you) on Transmeta
Efficeon, which has 2-way virtual cache tagging with hardware recovery,
zeropage coloring was a 1.5% performance improvement.

	-hpa

