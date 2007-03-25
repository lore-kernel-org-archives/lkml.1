Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972AbXCYRWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbXCYRWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 13:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbXCYRWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 13:22:19 -0400
Received: from smtpout07-04.prod.mesa1.secureserver.net ([64.202.165.233]:50608
	"HELO smtpout07.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751972AbXCYRWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 13:22:18 -0400
Message-ID: <4606AFC8.40104@kpfleming.us>
Date: Sun, 25 Mar 2007 10:22:16 -0700
From: "Kevin P. Fleming" <lkml@kpfleming.us>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Jan Beulich <jbeulich@novell.com>, Alan Cox <alan@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: drivers/pci/probe.c patch in 2.6.20.4 causes 'cannot adjust	BAR0
 (not I/O)' on NVidia MCP51
References: <460693EB.9080203@kpfleming.us> <20070325161144.GA12155@kroah.com>
In-Reply-To: <20070325161144.GA12155@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> Kevin, does 2.6.21-rc4 work properly for you?

No, it seems to exhibit the same behavior. However, I should note that
this laptop is not 100% stable under any kernel release anyway... in
text console mode it frequently locks up tight (although not with the
NVidia closed-source driver running and X started <G>).

I tried booting 2.6.21-rc4 five times and only once did it get pass
these messages during PCI probing, but it hung during the forcedeth
driver initialization.

I also forgot to note in my initial problem report that the PCI device
being referred to in the messages is the MCP51 IDE interface (although
that could have been assumed from what the patch is supposed to do).
