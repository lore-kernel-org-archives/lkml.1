Return-Path: <linux-kernel-owner+w=401wt.eu-S1161805AbXDYT43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161805AbXDYT43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161806AbXDYT43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:56:29 -0400
Received: from l2mail1.panix.com ([166.84.1.75]:51344 "EHLO l2mail1.panix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161805AbXDYT42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:56:28 -0400
Date: Wed, 25 Apr 2007 12:38:23 -0700 (PDT)
From: Kenneth Crudup <kenny@panix.com>
To: Pavel Machek <pavel@ucw.cz>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
 hang in atomic copy)
In-Reply-To: <20070425072904.GB6866@ucw.cz>
Message-ID: <Pine.LNX.4.64.0704251231440.8406@vaio.localdomain>
References: <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de>
 <20070418220228.GA14536@elte.hu> <1176947576.5906.21.camel@nigel.suspend2.net>
 <20070419070437.GA25211@elte.hu> <20070424202336.GC16503@elf.ucw.cz>
 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
 <20070424212408.GD16457@elf.ucw.cz> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
 <20070425064137.GA25247@elte.hu> <20070425072904.GB6866@ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Apr 2007, Pavel Machek wrote:

> You'll miss compression part, but that provides only small speedup.

Not here:

----
fgrep -h Compressed /var/log/rawlog*
Apr 22 13:41:34 vaio kernel:   Compressed 85655552 bytes into 46779248 (45 percent compression).
Apr 22 16:09:13 vaio kernel:   Compressed 1380552704 bytes into 435656971 (68 percent compression).
Apr 22 17:06:11 vaio kernel:   Compressed 1488437248 bytes into 437400026 (70 percent compression).
Apr 22 22:55:41 vaio kernel:   Compressed 1875677184 bytes into 623450953 (66 percent compression).
Apr 23 12:30:33 vaio kernel:   Compressed 1731796992 bytes into 528194347 (69 percent compression).
Apr 23 18:13:32 vaio kernel:   Compressed 1883869184 bytes into 691016832 (63 percent compression).
Apr 24 11:55:07 vaio kernel:   Compressed 1795903488 bytes into 703370960 (60 percent compression).
<snip>
----

	-Kenny

-- 
Kenneth R. Crudup  Sr. SW Engineer, Scott County Consulting, Los Angeles
O: 3630 S. Sepulveda Blvd. #138, L.A., CA 90034-6809      (888) 454-8181
