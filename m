Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974Ab0A1BlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab0A1BlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 20:41:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918Ab0A1BlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 20:41:15 -0500
Received: from mga03.intel.com ([143.182.124.21]:27422 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab0A1BlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 20:41:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="237629875"
Subject: Re: kernel error : 'find /proc/ -type f | xargs -n 1 head -c 10
 >/dev/null'
From: Zhang Rui <rui.zhang@intel.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.00.1001261416430.15694@twin.jikos.cz>
References: <201001212017.00160.toralf.foerster@gmx.de>
	 <20100121203535.GA5133@x200> <201001212219.03718.toralf.foerster@gmx.de>
	 <alpine.LRH.2.00.1001261416430.15694@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jan 2010 09:39:27 +0800
Message-ID: <1264642767.22448.633.camel@rzhang1-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-26 at 21:17 +0800, Jiri Kosina wrote:
> [ adding relevant CCs ]
> 
> On Thu, 21 Jan 2010, Toralf Förster wrote:
> 
> > Alexey Dobriyan wrote at 21:35:35
> > > On Thu, Jan 21, 2010 at 08:16:59PM +0100, Toralf Förster wrote:
> > > > I was inspired by http://article.gmane.org/gmane.linux.kernel/941115 .
> > > >
> > > > Running the command (se subject) as a normal user at a 2.6.32.4 kernel
> > > > gives this in /var/log/messages:
> > > >
> > > > head: page allocation failure. order:9, mode:0xd0
> > > > Pid: 2324, comm: head Not tainted 2.6.32.4 #1
> > > > Call Trace:
> > > > [<c106e2cc>] ? __alloc_pages_nodemask+0x4bc/0x5a0
> > > > [<c108cf5a>] ? cache_alloc_refill+0x2ba/0x510
> > > > [<c108d299>] ? __kmalloc+0xe9/0xf0
> > > > [<c10aa755>] ? seq_read+0x195/0x370
> > > 
> > > Please, find out which file is causing this, if it's reproducible.
> > > 
> > I reproduced the msg :
> > "ACPI: Please implement acpi_video_bus_ROM_seq_show" by :
> > by
> > $> head -c 10 /proc/acpi/video/VID/info
> > 
this is just a KERN_INFO message that suggests the
acpi_video_bus_ROM_seq_show method is not actually implemented right
now.

I don't think it has anything to do with the trace. :)

thanks,
rui

> > After suspend to disk and wakeup however the file /proc/acpi/video/VID/ROM was 
> > the culprit.
> > 
> > The trace however I can't reproduce until now.
> > 
> > 
> > 
> 


