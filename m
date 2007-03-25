Return-Path: <linux-kernel-owner+w=401wt.eu-S1751789AbXCYQMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbXCYQMa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 12:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbXCYQMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 12:12:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35687 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbXCYQM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 12:12:29 -0400
Date: Sun, 25 Mar 2007 09:11:44 -0700
From: Greg KH <greg@kroah.com>
To: "Kevin P. Fleming" <lkml@kpfleming.us>, Jan Beulich <jbeulich@novell.com>,
       Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: drivers/pci/probe.c patch in 2.6.20.4 causes 'cannot adjust
	BAR0 (not I/O)' on NVidia MCP51
Message-ID: <20070325161144.GA12155@kroah.com>
References: <460693EB.9080203@kpfleming.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <460693EB.9080203@kpfleming.us>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 08:23:23AM -0700, Kevin P. Fleming wrote:
> I just upgraded from 2.6.20.2 to 2.6.20.4 on my Compaq V6000 laptop,
> which has an NVidia core chipset. It has the MCP51 and uses it for PATA
> and SATA.
> 
> Booting the 2.6.20.4 kernel causes two messages (and a kernel lockup)
> like this:
> 
> 0000:00:0d.0: cannot adjust BAR0 (not I/O)
> 0000:00:0d.0: cannot adjust BAR1 (not I/O)
> 
> Booting without ACPI, without APIC, without LAPIC makes no usable
> difference (although sometimes I will also receive a message about BAR2).
> 
> This patch:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ed8ccee0918ad063a4741c0656fda783e02df627;hp=9e5755bce00bb563739aeb0f09932a1907521167
> 
> is the cause... backing it out results in a working 2.6.20.4 kernel on
> my laptop.
> 
> I'll be happy to provide any assistance I can debugging this problem.

Jan, any thoughts about this?

Should this be backed out of the -stable releases?

Kevin, does 2.6.21-rc4 work properly for you?

thanks,

greg k-h
