Return-Path: <linux-kernel-owner+w=401wt.eu-S1763307AbXHCSGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763307AbXHCSGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 14:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759475AbXHCSGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 14:06:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52175 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758736AbXHCSGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 14:06:33 -0400
Date: Fri, 3 Aug 2007 11:06:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?Q?Rafa=C5=82?= Bilski <rafalbilski@interia.pl>
Cc: linux-mtd@lists.infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problem with udev and block2mtd
Message-Id: <20070803110614.9c06fe45.akpm@linux-foundation.org>
In-Reply-To: <46B0D997.8030805@interia.pl>
References: <46B0D997.8030805@interia.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Aug 2007 21:05:59 +0200
Rafał Bilski <rafalbilski@interia.pl> wrote:

> Hi!
> 
> I have changed static /dev to udev on my machine. It has 
> a lot of RAM (94MB) so I was expecting that udev will not make 
> things worse. Unfortunately udev isn't noticing that new mtd 
> device was born.

<tap, tap>  Is this thing turned on?

> I was suspecting that this is my fault, but 
> udev's /dev is populated and:
> UEVENT[1185991604.930847] add@/module/mtdcore
> UEVENT[1185991604.969089] add@/module/mtdpart
> UEVENT[1185991605.005954] add@/module/block2mtd
> UEVENT[1185991647.726551] add@/module/mtdsuper
> UEVENT[1185991647.783396] add@/module/jffs2
> UEVENT[1185991647.801242] add@/slab/jffs2_i
> UDEV  [1185991647.815670] add@/slab/jffs2_i
> UEVENT[1185991647.827608] add@/slab/:0000072
> UDEV  [1185991647.842338] add@/slab/:0000072
> I don't see nothing about new device.
> 
> Is this situation known? Or this is 2.6.23-rc1-git3 regression? 
> Or is my udev misconfigured?
> 

Did 2.6.22 work OK with the same setup?  If so, yes, it's a regression!
