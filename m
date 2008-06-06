Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbYFFMkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbYFFMkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 08:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbYFFMk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 08:40:28 -0400
Received: from mail.queued.net ([207.210.101.209]:4861 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814AbYFFMk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 08:40:28 -0400
Date: Fri, 6 Jun 2008 08:46:33 -0400
From: Andres Salomon <dilinger@queued.net>
To: Pavel Machek <pavel@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
       rmh@aybabtu.com
Subject: Re: [PATCH] OLPC: pci: fix up PCI stuff so that PCI_GOANY supports
 OLPC
Message-ID: <20080606084633.65f69d73@ephemeral>
In-Reply-To: <20080606110549.GA5396@elf.ucw.cz>
References: <20080605152914.6f4ca839@ephemeral>
	<20080606110549.GA5396@elf.ucw.cz>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 13:05:49 +0200
Pavel Machek <pavel@suse.cz> wrote:

> On Thu 2008-06-05 15:29:14, Andres Salomon wrote:
> > Previously, one would have to specifically choose CONFIG_OLPC and
> > CONFIG_PCI_GOOLPC in order to enable PCI_OLPC.  That doesn't really
> > work for distro kernels, so this patch allows one to choose
> 
> How do distros work on OLPC, anyway? It lacks normal BIOS, so you
> can't really use GRUB, right?
> 								Pavel

I believe Robert was actually working on grub support.  I thought it made
little sense within the context of OFW, but if it is a requirement to make
installers happy, so be it.
