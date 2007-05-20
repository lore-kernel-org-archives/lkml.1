Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbXETRCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbXETRCY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 13:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758270AbXETRCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 13:02:17 -0400
Received: from mail.fieldses.org ([66.93.2.214]:38381 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758102AbXETRCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 13:02:17 -0400
Date: Sun, 20 May 2007 13:01:49 -0400
To: zilvinas@wilibox.com
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel NFS lockd freezes notebook on shutdown (Linux 2.6.22-rc1 + CFS v12)
Message-ID: <20070520170149.GA27420@fieldses.org>
References: <1179338441.4265.13.camel@zv.wilibox.com> <20070516121538.7b108c10.akpm@linux-foundation.org> <20070516225543.GA337@tv-sign.ru> <1179390065.4760.5.camel@zv.wilibox.com> <20070517184556.GA81@tv-sign.ru> <1179485230.3800.20.camel@zv.wilibox.com> <20070518202805.GA298@tv-sign.ru> <Pine.LNX.4.64.0705201326410.8634@barclay.balt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705201326410.8634@barclay.balt.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 01:37:13PM +0300, zilvinas@wilibox.com wrote:
> Hello Oleg,
> 
> I've done some more tests and quite frankly I think this is really related 
> to the dreaded ''fglrx.ko'' module. It seems to me that it is much easier 
> to reproduce the problem if that damn module is loaded. It does uses 
> workqueue. Then there is another driver ipw3945 loaded and it is required 
> to run binary only ''ipw3945d'' daemon just to start using wireless driver 
> ...
> 
> In either way both these kernel modules are workqueue users.

Have you ever been able to reproduce the problem on a kernel that never
had those modules loaded?

--b.
