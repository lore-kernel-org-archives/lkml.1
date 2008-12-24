Return-Path: <linux-kernel-owner+w=401wt.eu-S1752705AbYLXIxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbYLXIxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 03:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYLXIxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 03:53:10 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36825 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbYLXIxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 03:53:09 -0500
Date: Wed, 24 Dec 2008 09:53:01 +0100
From: Pavel Machek <pavel@suse.cz>
To: John Ogness <dazukocode@ogness.net>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 0/5] VFS: DazukoFS, stackable-fs, file access control
Message-ID: <20081224085300.GA1539@ucw.cz>
References: <86d4flh96z.fsf@johno-ibook.fn.ogness.net> <20081223115428.GB1439@ucw.cz> <864p0u202o.fsf@johno-ibook.fn.ogness.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864p0u202o.fsf@johno-ibook.fn.ogness.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-12-23 19:55:27, John Ogness wrote:
> On 2008-12-23, Pavel Machek <pavel@suse.cz> wrote:
> >> MOTIVATION
> >> 
> >> Since 2001 various anti-virus vendors have been providing
> >> out-of-tree solutions for online virus scanning. Although GNU/Linux
> >> systems currently are not targets of virus authors, many
> >> organizations are interested in online virus scanning on
> >> Linux-based servers in order to help protect Microsoft Windows
> >> clients. It is often argued that file scanning should be
> >> implemented in the various services (such as Samba, Apache, vsftpd,
> >> etc.), and indeed many such solutions have been
> >> implemented. However, there is a continued demand for a
> >> kernel-based solution because it can guard the entire filesystem
> >> independent from the types and numbers of services running on a
> >> system.
> >
> > Somewhere here you should mention that unlike other solutions that
> > work 100% of time, dazuko is be design racy and may still allow
> > viruses to be spread from linux system when mmap is used.
> 
> This thread is about DazukoFS. I feel there is no need to discuss
> previous incarnations of Dazuko, all of which share _no_ code with
> DazukoFS.
> 
> If you are aware of a race condition in DazukoFS, please report
> it. Thank you.

I'm surprised, do you claim there is none?

So how do you handle mmap(...MAP_SHARED) case? 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
