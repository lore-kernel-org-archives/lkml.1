Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbXCYTGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbXCYTGn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 15:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbXCYTGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 15:06:43 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33303 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752030AbXCYTGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 15:06:42 -0400
Date: Sun, 25 Mar 2007 21:08:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: "Kevin P. Fleming" <lkml@kpfleming.us>, Jan Beulich <jbeulich@novell.com>,
       Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: drivers/pci/probe.c patch in 2.6.20.4 causes 'cannot adjust
 BAR0 (not I/O)' on NVidia MCP51
Message-ID: <20070325210846.05d3f2c8@the-village.bc.nu>
In-Reply-To: <20070325161144.GA12155@kroah.com>
References: <460693EB.9080203@kpfleming.us>
	<20070325161144.GA12155@kroah.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Jan, any thoughts about this?
> Should this be backed out of the -stable releases?

All the code does if it prints that message.. is print that message.

The fact the message appears at all appears to indicate a slightly odd
BIOS but since the values in those registers are undefined in this mode
its not technically invalid. 

I don't believe the hang is related to this change.

Alan
