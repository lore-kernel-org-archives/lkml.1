Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252Ab0AUVTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252Ab0AUVTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 16:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710Ab0AUVTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 16:19:09 -0500
Received: from mail.gmx.net ([213.165.64.20]:46560 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753140Ab0AUVTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 16:19:08 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19vX3tT/OVvsyL4v/0zadLs6r1rC2DTG8DgyZVzsg
	LUAX++zu8Z/ZIq
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: kernel error : 'find /proc/ -type f | xargs -n 1 head -c 10 >/dev/null'
Date: Thu, 21 Jan 2010 22:19:03 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32.4; KDE/4.3.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <201001212017.00160.toralf.foerster@gmx.de> <20100121203535.GA5133@x200>
In-Reply-To: <20100121203535.GA5133@x200>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001212219.03718.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57999999999999996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alexey Dobriyan wrote at 21:35:35
> On Thu, Jan 21, 2010 at 08:16:59PM +0100, Toralf Förster wrote:
> > I was inspired by http://article.gmane.org/gmane.linux.kernel/941115 .
> >
> > Running the command (se subject) as a normal user at a 2.6.32.4 kernel
> > gives this in /var/log/messages:
> >
> > head: page allocation failure. order:9, mode:0xd0
> > Pid: 2324, comm: head Not tainted 2.6.32.4 #1
> > Call Trace:
> > [<c106e2cc>] ? __alloc_pages_nodemask+0x4bc/0x5a0
> > [<c108cf5a>] ? cache_alloc_refill+0x2ba/0x510
> > [<c108d299>] ? __kmalloc+0xe9/0xf0
> > [<c10aa755>] ? seq_read+0x195/0x370
> 
> Please, find out which file is causing this, if it's reproducible.
> 
I reproduced the msg :
"ACPI: Please implement acpi_video_bus_ROM_seq_show" by :
by
$> head -c 10 /proc/acpi/video/VID/info

After suspend to disk and wakeup however the file /proc/acpi/video/VID/ROM was 
the culprit.

The trace however I can't reproduce until now.


-- 
MfG/Sincerely
Toralf Förster
