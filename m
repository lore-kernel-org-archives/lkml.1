Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab0BBVUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:20:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36538 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab0BBVUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:20:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [Bug #14894] pohmelfs: NULL pointer dereference
Date: Tue, 2 Feb 2010 22:21:09 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>, GregKH <greg@kroah.com>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <20091230091433.GU4489@kernel.dk> <20100202205743.GA26703@ioremap.net>
In-Reply-To: <20100202205743.GA26703@ioremap.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002022221.09895.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 February 2010, Evgeniy Polyakov wrote:
> Hi.
> 
> Sorry, it took really long to catch all the things around, but it is
> better than never.
> 
> History says that commit which introduced per-bdi writeback broke
> pohmelfs, since it does not have backing store device and did not fill
> appropriate superblock entry, which lead to crash on umoount.
> 
> Jens provided a patch below, which I tested to fix the problem.

Thanks, I've linked the Jens' patch to the bugzilla entry and marked the
bug as resolved.

Rafael
