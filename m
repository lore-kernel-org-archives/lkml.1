Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbYHNWdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbYHNWdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 18:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYHNWdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 18:33:42 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:55446 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbYHNWdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 18:33:40 -0400
Date: Fri, 15 Aug 2008 00:35:00 +0200
From: Pavel Machek <pavel@suse.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: tvrtko.ursulin@sophos.com, Arjan van de Ven <arjan@infradead.org>,
       Adrian Bunk <bunk@kernel.org>, davecb@sun.com, Greg KH <greg@kroah.com>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       Mihai Don??u <mdontu@bitdefender.com>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a
	linuxinterfaceforon access scanning
Message-ID: <20080814223500.GB6370@elf.ucw.cz>
References: <20080813065401.1bbdcb07@infradead.org> <20080813141618.696833764EA@pmx1.sophos.com> <20080814125613.GB2262@elf.ucw.cz> <20080814210604.7bdea3ea@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814210604.7bdea3ea@lxorguk.ukuu.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-08-14 21:06:04, Alan Cox wrote:
> > > LD_PRELOAD does not solve at least knfsd and suid binaries. But we are 
> > > going in circles. :)
> > 
> > Yes, there are about 5 suid binaries on typical linux system. Link
> > them to libmalware by hand
> 
> And knfsd ?
> 
> Oh yes you don't seem to have an answer just manure to throw

I think I acknowledged inability to handle knfsd... just don't use
knfsd, then. Its not like nfs is critical for communicating with
Windows, right?

That is still better than proposed solution here -- TALPA breaks with
mmap, or when someone does read too soon after write. 

Marketing "antivirus" system that is racy be design seems to deserve
some manure.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
