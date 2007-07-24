Return-Path: <linux-kernel-owner+w=401wt.eu-S932460AbXGXUlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460AbXGXUlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932408AbXGXUkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:40:47 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59092 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336AbXGXUkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:40:45 -0400
Message-ID: <46A663CA.3050000@garzik.org>
Date: Tue, 24 Jul 2007 16:40:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "Maciej W. Rozycki" <macro@linux-mips.org>,
       =?ISO-8859-1?Q?S=E9bastie?= =?ISO-8859-1?Q?n_Dugu=E9?= 
	<sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to
 platform devices - broke my serial console
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <200707241353.57458.bjorn.helgaas@hp.com> <46A65D7D.6040409@garzik.org> <200707241434.32374.bjorn.helgaas@hp.com>
In-Reply-To: <200707241434.32374.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Tuesday 24 July 2007 02:13:49 pm Jeff Garzik wrote:
>> Bjorn Helgaas wrote:
>>>   - Linux enumerates CPUs with the MADT; I think Windows uses the ACPI
>>>     namespace.  Sometimes there are multiple MADTs, and sometimes Linux
>>>     uses the wrong one.
>> Color me skeptical.  I think we would have bug reports if we were really 
>> getting this wrong a lot of the time.
> 
> We do have bug reports, like http://bugzilla.kernel.org/show_bug.cgi?id=7465
> Not very many, but enough that I'd like to get to the root cause.
> 
>> You seem to be missing that ignoring BIOS is often a VERY GOOD thing, 
>> that has served us well many many times in the past.
> 
> I can see that I'm not going to win this argument :-)
> 
> But I would like to find and fix the problem with Sebastien's machine,
> because the patch does fix real problems with IRDA and I think the fix
> for Sebastien is likely to fix other PNP issues.

Please go back and fix the original issue!

If you are having problems caused by double-probing, the fix is NOT to 
remove one the probes.  The fix is to ensure use of proper resource 
reservation, and in some cases, add co-driver-awareness.

Your entire justification for the patch has not been proven, since you 
demonstrably have not solved the original bug for which your patch was 
intended to solve.

	Jeff


