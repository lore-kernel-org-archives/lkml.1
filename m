Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565Ab0AZNRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab0AZNRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 08:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087Ab0AZNRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 08:17:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab0AZNRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 08:17:34 -0500
Date: Tue, 26 Jan 2010 14:17:32 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: =?ISO-8859-15?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>
Subject: Re: kernel error : 'find /proc/ -type f | xargs -n 1 head -c 10
 >/dev/null'
In-Reply-To: <201001212219.03718.toralf.foerster@gmx.de>
Message-ID: <alpine.LRH.2.00.1001261416430.15694@twin.jikos.cz>
References: <201001212017.00160.toralf.foerster@gmx.de> <20100121203535.GA5133@x200> <201001212219.03718.toralf.foerster@gmx.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ adding relevant CCs ]

On Thu, 21 Jan 2010, Toralf Förster wrote:

> Alexey Dobriyan wrote at 21:35:35
> > On Thu, Jan 21, 2010 at 08:16:59PM +0100, Toralf Förster wrote:
> > > I was inspired by http://article.gmane.org/gmane.linux.kernel/941115 .
> > >
> > > Running the command (se subject) as a normal user at a 2.6.32.4 kernel
> > > gives this in /var/log/messages:
> > >
> > > head: page allocation failure. order:9, mode:0xd0
> > > Pid: 2324, comm: head Not tainted 2.6.32.4 #1
> > > Call Trace:
> > > [<c106e2cc>] ? __alloc_pages_nodemask+0x4bc/0x5a0
> > > [<c108cf5a>] ? cache_alloc_refill+0x2ba/0x510
> > > [<c108d299>] ? __kmalloc+0xe9/0xf0
> > > [<c10aa755>] ? seq_read+0x195/0x370
> > 
> > Please, find out which file is causing this, if it's reproducible.
> > 
> I reproduced the msg :
> "ACPI: Please implement acpi_video_bus_ROM_seq_show" by :
> by
> $> head -c 10 /proc/acpi/video/VID/info
> 
> After suspend to disk and wakeup however the file /proc/acpi/video/VID/ROM was 
> the culprit.
> 
> The trace however I can't reproduce until now.
> 
> 
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

