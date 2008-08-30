Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbYH3N3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbYH3N3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 09:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYH3N3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 09:29:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56465 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbYH3N3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 09:29:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Date: Sat, 30 Aug 2008 15:32:55 +0200
User-Agent: KMail/1.9.9
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org> <86802c440808291720w67de2285yc8cf645ff3b70666@mail.gmail.com> <86802c440808291727nbd297c0w8a2a60bed423c0f7@mail.gmail.com>
In-Reply-To: <86802c440808291727nbd297c0w8a2a60bed423c0f7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808301532.57307.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 30 of August 2008, Yinghai Lu wrote:
> On Fri, Aug 29, 2008 at 5:20 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > On Fri, Aug 29, 2008 at 5:08 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> >>
> >>
> >> On Fri, 29 Aug 2008, Yinghai Lu wrote:
> >>> >
> >>> > http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/broken.log
> >>>
> >>> pci 0000:00:00.0: BAR has MMCONFIG at e0000000-ffffffff
> >>
> >> And that seems utter crap to begin with.
> >>
> >>        PCI: Using MMCONFIG at e0000000 - efffffff
> >>
> >> Where did it get that bogus "ffffffff" end address?
> >>
> >> Anyway, that whole MMCONFIG/BAR thing was totally broken to begin with,
> >> and it's reverted now in my tree, so I guess it doesn't much matter.
> >
> > we need to handle it. otherwise if the BAR go first, and it will stop
> > other BARs to be registered...
> >
> > a quirk should do the work....
> >
> > Rafael, can you send out lspci -tv and lspci --vvxxx too.
> 
> cat /proc/iomem please.

http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/lspci-tv.txt
http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/lspci-vvxxx.txt
http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/proc_iomem.txt

Thanks,
Rafael
