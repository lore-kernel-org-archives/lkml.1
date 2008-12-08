Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbYLHOyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbYLHOyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 09:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbYLHOyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 09:54:44 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56941 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbYLHOyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 09:54:43 -0500
Date: Mon, 8 Dec 2008 15:54:42 +0100
From: Pavel Machek <pavel@suse.cz>
To: Michael Chan <mchan@broadcom.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, benli@broadcom.com
Subject: Re: bnx2: fs_sync_timeout, reset code = 1020002
Message-ID: <20081208145442.GA23820@atrey.karlin.mff.cuni.cz>
References: <20081204105550.GA2429@elf.ucw.cz> <1228411378.9156.52.camel@HP1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228411378.9156.52.camel@HP1>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Thu, 2008-12-04 at 02:55 -0800, Pavel Machek wrote:
> > Hi!
> > 
> > I'm getting `subj` (with different numbers, 1020002, 1020004,
> > sometimes 102006). ifconfig eth0 up fails, network is completely
> > broken.
> 
> Which kernel are you using?  If it used to work before 2.6.26 or so,
> it

I'm using 2.6.28-rc7. I did not try any previous kernels.

> may be because of the PCI VPD access going beyond the size limit.  We
> should have a PCI quirk to prevent this, but may be it is not
> complete.

I could not find quirk handling, so I enabled the debug and workaround
options I could find...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
