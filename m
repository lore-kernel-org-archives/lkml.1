Return-Path: <linux-kernel-owner+w=401wt.eu-S1764599AbZE1UsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764599AbZE1UsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761217AbZE1UsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:48:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48794 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758689AbZE1UsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:48:06 -0400
Date: Thu, 28 May 2009 22:48:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, niel.lambrechts@gmail.com,
       linux-kernel@vger.kernel.org, gregkh@suse.de, rjw@sisk.pl
Subject: Re: 2.6.29.4: hibernation fails with large kernel trace
Message-ID: <20090528204802.GE11477@elf.ucw.cz>
References: <4A1C36FF.4080000@gmail.com> <20090527223241.c6fb2caf.akpm@linux-foundation.org> <E1M9ZJI-0003bh-HD@pomaz-ex.szeredi.hu> <20090528114527.GA2140@elf.ucw.cz> <E1M9hBl-0004dv-KT@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1M9hBl-0004dv-KT@pomaz-ex.szeredi.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-05-28 17:06:37, Miklos Szeredi wrote:
> On Thu, 28 May 2009, Pavel Machek wrote:
> > In the meantime, people should stop/restart fuse around
> > suspend/hibernation, I guess...
> 
> Which is not possible if the filesystem is busy, and it _will_ be busy
> in all cases where we now see freeze failures.

Well, maybe people will need to kill few processes to get it to
suspend :-(.

> And just a reminder that this problem is not fuse specific: similar
> freeze failures can also happen for network filesystems routed over a
> tun/tap device (e.g. NFS over OpenVPN).

Agreed, general solution would be nice. In NFS over OpenVPN case,
people will need to unmount NFS :-(, and maybe kill processes to do
that.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
