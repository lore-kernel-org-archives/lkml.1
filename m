Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbXLUWbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbXLUWbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 17:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754851AbXLUWbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 17:31:15 -0500
Received: from mail.suse.de ([195.135.220.2]:47815 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515AbXLUWbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 17:31:13 -0500
Date: Fri, 21 Dec 2007 14:29:56 -0800
From: Greg KH <gregkh@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, bjorn.helgaas@hp.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, dbrownell@users.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch 3/3] PCI: use dev_printk in x86 quirk messages
Message-ID: <20071221222956.GB24478@suse.de>
References: <20071217210937.103111394@ldl.fc.hp.com> <20071217211337.545932066@ldl.fc.hp.com> <20071218135801.GB17470@elte.hu> <20071221134735.1e0066c9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071221134735.1e0066c9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 01:47:35PM -0800, Andrew Morton wrote:
> On Tue, 18 Dec 2007 14:58:01 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * bjorn.helgaas@hp.com <bjorn.helgaas@hp.com> wrote:
> > 
> > > Convert quirk printks to dev_printk().
> > 
> > thanks, applied the x86 bits.
> > 
> 
> Greg applied it too.  Could you guys please sort out some sort of
> who-owns-what protocol?
> 
> Thanks.
> 
> > arch/x86/kernel/quirks.c |   42 ++++++++++++++++++++++--------------------
> > arch/x86/pci/fixup.c     |   22 +++++++++++-----------
> 
> That made it hard.  Arguably one file is PCI tree and the other is x86
> tree.

Hm, as traditionally we haven't had such an active x86 maintainer, I've
handled most of the pci quirk type stuff that people have sent to me in
the past :)

But, now that we have more enthusiastic developers, I can change this.
If you want me to cut portions of the patch up, I'll be glad to do so,
just let me know.

It's easy for me when merging, as our tools can handle it just fine, but
Andrew is the one with the big problems, so we should probably shake it
out on our end first...

Ingo, what is easiest for you to do?  As I use quilt, I can very simply
cut a portion of the patch up, or drop it entirely.

thanks,

greg k-h
