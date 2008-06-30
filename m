Return-Path: <linux-kernel-owner+w=401wt.eu-S1759314AbYF3X6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbYF3X6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 19:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754287AbYF3X6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 19:58:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753620AbYF3X6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 19:58:21 -0400
Date: Mon, 30 Jun 2008 16:57:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: lenb@kernel.org, jbarnes@virtuousgeek.org, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, linux-acpi@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/5] x86 PCI: use dev_printk when possible
Message-Id: <20080630165737.2f9735f0.akpm@linux-foundation.org>
In-Reply-To: <20080613165304.842091464@ldl.fc.hp.com>
References: <20080613165209.507694130@ldl.fc.hp.com>
	<20080613165304.842091464@ldl.fc.hp.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 10:52:14 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> I converted DBG() to dev_dbg().  This DBG() is from arch/x86/pci/pci.h
> and requires source-code modification to enable, so dev_dbg() seems
> roughly equivalent.
> 
> The printks in arch/x86/pci/irq.c were a little hairy, with lines
> printed in several pieces.  I straightened it out a little, but
> another set of eyes would be good.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> ---
>  arch/x86/pci/fixup.c |    3 +
>  arch/x86/pci/i386.c  |   26 ++++++--------
>  arch/x86/pci/irq.c   |   91 ++++++++++++++++++++++-----------------------------
>  arch/x86/pci/numa.c  |    5 +-

Got a bunch of rejects in arch/x86/pci/irq.c due to pending whitespace
fixes.  I fixed a couple of them but then I got bored, so the
conversion in there is only partial.

Please prefer to raise patches against linux-next if poss, especially
during late -rc's.

