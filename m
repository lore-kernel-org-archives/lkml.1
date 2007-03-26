Return-Path: <linux-kernel-owner+w=401wt.eu-S933387AbXCZCZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387AbXCZCZs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 22:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933410AbXCZCZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 22:25:48 -0400
Received: from smtpout07-04.prod.mesa1.secureserver.net ([64.202.165.233]:60771
	"HELO smtpout07.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S933387AbXCZCZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 22:25:47 -0400
Message-ID: <46072F2A.9060803@kpfleming.us>
Date: Sun, 25 Mar 2007 19:25:46 -0700
From: "Kevin P. Fleming" <lkml@kpfleming.us>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Jan Beulich <jbeulich@novell.com>, Alan Cox <alan@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: drivers/pci/probe.c patch in 2.6.20.4 causes 'cannot adjust BAR0
 (not I/O)' on NVidia MCP51
References: <460693EB.9080203@kpfleming.us> <20070325161144.GA12155@kroah.com> <20070325210846.05d3f2c8@the-village.bc.nu> <20070325192127.GR16477@stusta.de>
In-Reply-To: <20070325192127.GR16477@stusta.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> It also adds PCI_BASE_ADDRESS_SPACE_IO to the flags which it didn't 
> without the patch.

As an experiment I modified 2.6.20.4 to _only_ remove that value from
the combined value for the flags and it did not help in any noticeable
way. I can reliably boot and operate the machine with the original patch
reversed, though.
