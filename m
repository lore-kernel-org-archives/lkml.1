Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbYLZSai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbYLZSai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 13:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYLZSaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 13:30:30 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37638 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYLZSa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 13:30:29 -0500
Date: Fri, 26 Dec 2008 19:30:19 +0100
From: Pavel Machek <pavel@suse.cz>
To: John Ogness <dazukocode@ogness.net>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       malware-list@lists.printk.net, eparis@redhat.com, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 0/5] VFS: DazukoFS, stackable-fs, file access control
Message-ID: <20081226183019.GB1528@ucw.cz>
References: <86d4flh96z.fsf@johno-ibook.fn.ogness.net> <20081223115428.GB1439@ucw.cz> <864p0u202o.fsf@johno-ibook.fn.ogness.net> <20081224085300.GA1539@ucw.cz> <86d4fhwz66.fsf@johno-ibook.fn.ogness.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86d4fhwz66.fsf@johno-ibook.fn.ogness.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-12-24 13:11:29, John Ogness wrote:
> On 2008-12-24, Pavel Machek <pavel@suse.cz> wrote:
> >> If you are aware of a race condition in DazukoFS, please report
> >> it. Thank you.
> >
> > I'm surprised, do you claim there is none?
> 
> It depends on how you want to define "race condition". DazukoFS (in
> its current form) closes as many holes as default UNIX permissions or
> SElinux. However, changing permissions (i.e. scanning files) _after_
> two parties already have an open handle to the file is currently not
> covered. But this issue is not unique to DazukoFS (although as a
> stackable filesystem, DazukoFS could support this case as well).

Not unique to dazukofs, but regression to scanning at nfsd level,
right? So I guess it should be mentioned in changelog if you compare
yourself to solutions that do not have this problem.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
