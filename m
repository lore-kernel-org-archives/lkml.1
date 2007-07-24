Return-Path: <linux-kernel-owner+w=401wt.eu-S1764015AbXGXUfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764015AbXGXUfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbXGXUfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:35:42 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:42573 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbXGXUfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:35:41 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Date: Tue, 24 Jul 2007 14:34:32 -0600
User-Agent: KMail/1.9.6
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       =?iso-8859-1?q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <200707241353.57458.bjorn.helgaas@hp.com> <46A65D7D.6040409@garzik.org>
In-Reply-To: <46A65D7D.6040409@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707241434.32374.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2007 02:13:49 pm Jeff Garzik wrote:
> Bjorn Helgaas wrote:
> >   - Linux enumerates CPUs with the MADT; I think Windows uses the ACPI
> >     namespace.  Sometimes there are multiple MADTs, and sometimes Linux
> >     uses the wrong one.
> 
> Color me skeptical.  I think we would have bug reports if we were really 
> getting this wrong a lot of the time.

We do have bug reports, like http://bugzilla.kernel.org/show_bug.cgi?id=7465
Not very many, but enough that I'd like to get to the root cause.

> You seem to be missing that ignoring BIOS is often a VERY GOOD thing, 
> that has served us well many many times in the past.

I can see that I'm not going to win this argument :-)

But I would like to find and fix the problem with Sebastien's machine,
because the patch does fix real problems with IRDA and I think the fix
for Sebastien is likely to fix other PNP issues.

Bjorn
