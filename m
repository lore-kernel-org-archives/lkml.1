Return-Path: <linux-kernel-owner+w=401wt.eu-S936335AbXFGU11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936335AbXFGU11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760211AbXFGU1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:27:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57458 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759797AbXFGU1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:27:18 -0400
Date: Thu, 7 Jun 2007 13:27:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: 2.6.22-rc4-mm2 -- Bus #03 (-#06) is hidden behind transparent
 bridge #02 (-#02) (try 'pci=assign-busses')
Message-Id: <20070607132709.32cd9f4a.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0706071133w19272d8bkb392ffe58f1af6b7@mail.gmail.com>
References: <a44ae5cd0706071133w19272d8bkb392ffe58f1af6b7@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2007 11:33:12 -0700
"Miles Lane" <miles.lane@gmail.com> wrote:

> Andrew, is it okay to debug this with the MM tree?  I see this with
> Linus' kernels as well.  It's a long-standing issue, but I have always
> just used pci=assign-busses in the past.
> 

Dunno, but let's not miss an opportunity to bug the PCI maintainer.

>
> [    0.215128] PCI: Transparent bridge - 0000:00:1e.0
> [    0.215142] PCI: Scanning behind PCI bridge 0000:02:09.0, config
> 000000, pass 0
> [    0.215158] PCI: Scanning behind PCI bridge 0000:02:09.0, config
> 000000, pass 1
> [    0.215184] PCI: Bus #03 (-#06) is hidden behind transparent bridge
> #02 (-#02) (try 'pci=assign-busses')
> [    0.215187] Please report the result to linux-kernel to fix this permanently
> [    0.215192] PCI: Bus scan for 0000:02 returning with max=06
> [    0.215199] PCI: Scanning behind PCI bridge 0000:00:1e.0, config
> 020200, pass 1
> [    0.215209] PCI: Bus scan for 0000:00 returning with max=06
> 

Does the kernel otherwise work OK with and without pci=assign-busses?

