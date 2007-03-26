Return-Path: <linux-kernel-owner+w=401wt.eu-S964834AbXCZJw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834AbXCZJw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964792AbXCZJw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:52:26 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50187 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964834AbXCZJwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:52:25 -0400
Date: Mon, 26 Mar 2007 11:55:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jan Beulich" <jbeulich@novell.com>
Cc: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Kevin P. Fleming" <lkml@kpfleming.us>, "Greg KH" <greg@kroah.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: drivers/pci/probe.c patch in 2.6.20.4 causes 'cannot adjust
 BAR0 (not I/O)' on NVidia MCP51
Message-ID: <20070326115506.2b37f8de@the-village.bc.nu>
In-Reply-To: <46078B46.76E4.0078.0@novell.com>
References: <460693EB.9080203@kpfleming.us>
	<20070325161144.GA12155@kroah.com>
	<46078B46.76E4.0078.0@novell.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> patch did, though, it was that way already before. But otoh with the
> legacy flag set in progif, these BARs *should* be I/O ones...

They *are* I/O resources. The register value loaded by the BIOS or
hardware at start up is undefined and the "is memory" check is actually
wrong.

Doesn't explain the problem but does explain the message.
