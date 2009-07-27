Return-Path: <linux-kernel-owner+w=401wt.eu-S1755125AbZG0Asz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbZG0Asz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 20:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZG0Asy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 20:48:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:27924 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbZG0Asx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 20:48:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,273,1246863600"; 
   d="scan'208";a="169120078"
Date: Mon, 27 Jul 2009 08:48:51 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       MinChan Kim <minchan.kim@gmail.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [Bug #13665] commit 69c854817566 causes OOMs
Message-ID: <20090727004851.GA10495@localhost>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.44E.QIObKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3zAHs5O6maO.A.44E.QIObKB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 04:28:20AM +0800, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13665
> Subject		: commit 69c854817566 causes OOMs
> Submitter	: David Howells <dhowells@redhat.com>
> Date		: 2009-06-27 08:12 (30 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=69c854817566db82c362797b4a6521d0b00fe1d8
> References	: http://lkml.org/lkml/2009/6/27/28

Both patches from KOSAKI and Rik can fix the OOM in my tests:

http://lkml.org/lkml/2009/7/7/104
http://patchwork.kernel.org/patch/34740/

The latter one has been included in -mm

> Handled-By	: Wu Fengguang <fengguang.wu@intel.com>
> Patch		: http://patchwork.kernel.org/patch/32740/

This patch is also in -mm.

Thanks,
Fengguang

