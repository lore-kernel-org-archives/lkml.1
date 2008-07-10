Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbYGLHH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbYGLHH2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 03:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbYGLHHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 03:07:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2586 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751730AbYGLHHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 03:07:08 -0400
Date: Thu, 10 Jul 2008 20:24:18 +0200
From: Pavel Machek <pavel@suse.cz>
To: Enrico Weigelt <weigelt@metux.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: block devices in userland
Message-ID: <20080710182417.GC13483@ucw.cz>
References: <342518340@web.de> <20080705162902.GA26789@nibiru.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080705162902.GA26789@nibiru.local>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2008-07-05 18:29:02, Enrico Weigelt wrote:
> * devzero@web.de <devzero@web.de> wrote:
> > >is there an API for writing block device drivers in userland ?
> > 
> > i don`t know if there is some in vanilla, but maybe dm-userspace is worth taking a look at ?
> > see http://wiki.xensource.com/xenwiki/DmUserspace
> 
> hmm, doesn't seem to be what I'm looking for - it just leaves the 
> mapping of virtual to physical blocks to userland. 
> 
> What I need is passing the whole read/write requests to some userland
> deamon - these blocks won't come from any (in-kernel) block device,
> but an totally different kind of storage (eg. venti).

nbd, but be careful about deadlocks.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
