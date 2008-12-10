Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbYLJBbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbYLJBbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 20:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbYLJBbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 20:31:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835AbYLJBbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 20:31:03 -0500
Date: Tue, 9 Dec 2008 17:30:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, adobriyan@gmail.com,
       Greg <greg@kroah.com>, NeilBrown <neilb@suse.de>
Subject: Re: linux-next: Tree for December 9
Message-Id: <20081209173048.18382f6d.akpm@linux-foundation.org>
In-Reply-To: <ac3eb2510812091631j3b350ac6t9429e01171a96228@mail.gmail.com>
References: <20081209185237.8bb715d7.sfr@canb.auug.org.au>
	<20081209153418.4628723d.akpm@linux-foundation.org>
	<ac3eb2510812091606k5615135fn87d35aaa16834ea8@mail.gmail.com>
	<20081209161511.15fe8cdb.akpm@linux-foundation.org>
	<ac3eb2510812091631j3b350ac6t9429e01171a96228@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 01:31:13 +0100 "Kay Sievers" <kay.sievers@vrfy.org> wrote:

> > akpm2:/home/akpm# udevmonitor
> > udevmonitor prints the received event from the kernel [UEVENT]
> > and the event which udev sends out after rule processing [UDEV]
> >
> > UDEV  [1228867146.103334] add@/class/bdi/9:0
> > UDEV  [1228867146.107566] remove@/block/md0
> > UDEV  [1228867146.111969] remove@/class/bdi/9:0
> > UEVENT[1228867146.119889] add@/block/md0
> > UEVENT[1228867146.119964] add@/class/bdi/9:0
> > UEVENT[1228867146.120162] remove@/class/bdi/9:0
> > UEVENT[1228867146.120205] remove@/block/md0
> > UDEV  [1228867146.122839] add@/block/md0
> > UDEV  [1228867146.129125] add@/class/bdi/9:0
> > UDEV  [1228867146.133459] remove@/block/md0
> > UDEV  [1228867146.137813] remove@/class/bdi/9:0
> > UEVENT[1228867146.145652] add@/block/md0
> 
> Weird loop, something is accessing /dev/md0, i guess, which creates
> the kernel device, and the event, which accesses /dev/md0 again and it
> goes crazy. Maybe caused by changes Neil did.

I knew an Australian was to blame - it's just a matter of determining
which one.

> Do you use md devices on that box?

Nope.
