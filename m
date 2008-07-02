Return-Path: <linux-kernel-owner+w=401wt.eu-S1761422AbYGBB6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761422AbYGBB6U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757484AbYGBB6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:58:05 -0400
Received: from outbound-mail-07.bluehost.com ([69.89.17.207]:55592 "HELO
	outbound-mail-07.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756337AbYGBB6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:58:04 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 5/5] x86 PCI: use dev_printk when possible
Date: Tue, 1 Jul 2008 18:57:41 -0700
User-Agent: KMail/1.9.9
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, lenb@kernel.org, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-acpi@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080613165209.507694130@ldl.fc.hp.com> <20080613165304.842091464@ldl.fc.hp.com> <20080630165737.2f9735f0.akpm@linux-foundation.org>
In-Reply-To: <20080630165737.2f9735f0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011857.42384.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 30, 2008 4:57 pm Andrew Morton wrote:
> On Fri, 13 Jun 2008 10:52:14 -0600
>
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> > I converted DBG() to dev_dbg().  This DBG() is from arch/x86/pci/pci.h
> > and requires source-code modification to enable, so dev_dbg() seems
> > roughly equivalent.
> >
> > The printks in arch/x86/pci/irq.c were a little hairy, with lines
> > printed in several pieces.  I straightened it out a little, but
> > another set of eyes would be good.
> >
> > Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> >
> > ---
> >  arch/x86/pci/fixup.c |    3 +
> >  arch/x86/pci/i386.c  |   26 ++++++--------
> >  arch/x86/pci/irq.c   |   91
> > ++++++++++++++++++++++----------------------------- arch/x86/pci/numa.c 
> > |    5 +-
>
> Got a bunch of rejects in arch/x86/pci/irq.c due to pending whitespace
> fixes.  I fixed a couple of them but then I got bored, so the
> conversion in there is only partial.
>
> Please prefer to raise patches against linux-next if poss, especially
> during late -rc's.

Yeah, the x86 tree(s) move too fast for me to keep up with.  The change seems 
worthwhile though, maybe Ingo or one of the x86 team could just search & 
replace?

Jesse
