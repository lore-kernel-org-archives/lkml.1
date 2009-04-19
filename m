Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZDSRwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZDSRwj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 13:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbZDSRw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 13:52:29 -0400
Received: from outbound-mail-103.bluehost.com ([69.89.22.13]:47031 "HELO
	outbound-mail-103.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752778AbZDSRw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 13:52:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=UQMy5veiBf69C8vAtsZyD5Bq9/t1TcRGAJtCBpqOBI1n8hZf5vI3P2BA1+YM1c/XdKqormJ14mcejMKhdGqFaVhCCYS+kT2XLvUzQi2Bcks2UGpxYcXF3jVBfC6Cf1YF;
Date: Sun, 19 Apr 2009 10:52:24 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
Message-ID: <20090419105224.7ededc1d@hobbes>
In-Reply-To: <20090419090615.GA30631@elte.hu>
References: <49E76864.9060309@kernel.org>
	<20090416172803.GB16618@elte.hu>
	<49E7916C.7050701@kernel.org>
	<alpine.LFD.2.00.0904161540590.4042@localhost.localdomain>
	<49E99054.6050208@kernel.org>
	<alpine.LFD.2.00.0904181142530.4042@localhost.localdomain>
	<49EA57C4.1000603@kernel.org>
	<alpine.LFD.2.00.0904181602030.2199@localhost.localdomain>
	<alpine.LFD.2.00.0904182149240.2199@localhost.localdomain>
	<20090419090208.GA30211@elte.hu>
	<20090419090615.GA30631@elte.hu>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Apr 2009 11:06:15 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Cool! Yinghai, mind (re-)sending the latest version of the 
> > remaining two patches, so what we can pick this up into the x86 
> > tree and get it tested? I'd say it's for v2.6.31. (unless someone 
> > can think of a strong reason to do this sooner.)
> 
> Hm, there's one patch in that lot that does:
> 
>  drivers/pci/bus.c	 |    8 +++++++-
>  drivers/pci/probe.c     |    8 ++++++--
>  drivers/pci/setup-bus.c |   40
> +++++++++++++++++++++++++++++++--------- 3 files changed, 44
> insertions(+), 12 deletions(-)
> 
> Which should go via the PCI tree.
> 
> I can set up an isolated x86/pci-gap topic that i'll send to Jesse 
> to pull (once it looks to be stable), as the other patches modify 
> the e820 code which we'd like to test in the x86 tree first.
> 
> Jesse, Linus, Yinghai, does that look like a good plan to you?

Yep, that's fine with me.

-- 
Jesse Barnes, Intel Open Source Technology Center
