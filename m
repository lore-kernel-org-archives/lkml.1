Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbXETTV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbXETTV3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 15:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbXETTVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 15:21:21 -0400
Received: from mail.screens.ru ([213.234.233.54]:59342 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755847AbXETTVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 15:21:21 -0400
Date: Sun, 20 May 2007 23:21:16 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: zilvinas@wilibox.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: Kernel NFS lockd freezes notebook on shutdown (Linux 2.6.22-rc1 + CFS v12)
Message-ID: <20070520192116.GA83@tv-sign.ru>
References: <1179338441.4265.13.camel@zv.wilibox.com> <20070516121538.7b108c10.akpm@linux-foundation.org> <20070516225543.GA337@tv-sign.ru> <1179390065.4760.5.camel@zv.wilibox.com> <20070517184556.GA81@tv-sign.ru> <1179485230.3800.20.camel@zv.wilibox.com> <20070518202805.GA298@tv-sign.ru> <Pine.LNX.4.64.0705201326410.8634@barclay.balt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705201326410.8634@barclay.balt.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20, zilvinas@wilibox.com wrote:
> 
> I've done some more tests and quite frankly I think this is really related 
> to the dreaded ''fglrx.ko'' module. It seems to me that it is much easier 
> to reproduce the problem if that damn module is loaded. It does uses 
> workqueue. Then there is another driver ipw3945 loaded and it is required 
> to run binary only ''ipw3945d'' daemon just to start using wireless driver 
> ...
> 
> In either way both these kernel modules are workqueue users.
> 
> Btw, I had also tested kernel (compiled from the same source) but on 
> different laptop (EVO N800v), single core, Pentium M 2GHz. Kernel is not 
> freezing on shutdown, even loop nfs kernel stop/start - does not cause any 
> kernel panic as on nx9420 (Dual Core) laptop. And that with or without any 
> patch applied from Oleg. :((

Great. Even if not a bugfix, this patch is a reasonable cleanup anyway.

Thank you very much for additional testing and report!

Oleg.

