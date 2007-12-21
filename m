Return-Path: <linux-kernel-owner+w=401wt.eu-S1758335AbXLUVuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335AbXLUVuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 16:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbXLUVt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 16:49:59 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39958 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753421AbXLUVt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 16:49:58 -0500
Date: Fri, 21 Dec 2007 13:47:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: bjorn.helgaas@hp.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       gregkh@suse.de, dbrownell@users.sourceforge.net,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [patch 3/3] PCI: use dev_printk in x86 quirk messages
Message-Id: <20071221134735.1e0066c9.akpm@linux-foundation.org>
In-Reply-To: <20071218135801.GB17470@elte.hu>
References: <20071217210937.103111394@ldl.fc.hp.com>
	<20071217211337.545932066@ldl.fc.hp.com>
	<20071218135801.GB17470@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007 14:58:01 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * bjorn.helgaas@hp.com <bjorn.helgaas@hp.com> wrote:
> 
> > Convert quirk printks to dev_printk().
> 
> thanks, applied the x86 bits.
> 

Greg applied it too.  Could you guys please sort out some sort of
who-owns-what protocol?

Thanks.

> arch/x86/kernel/quirks.c |   42 ++++++++++++++++++++++--------------------
> arch/x86/pci/fixup.c     |   22 +++++++++++-----------

That made it hard.  Arguably one file is PCI tree and the other is x86
tree.
