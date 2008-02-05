Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYBEPzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYBEPzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 10:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbYBEPzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 10:55:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:37473 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750897AbYBEPzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:55:25 -0500
Date: Tue, 5 Feb 2008 16:55:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Abel Bernabeu <abel.bernabeu@gmail.com>
Subject: Re: brk randomization breaks columns
Message-ID: <20080205155513.GB24331@elf.ucw.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz> <Pine.LNX.4.64.0802051243240.542@blonde.site> <20080205070001.7bc8058f@laptopd505.fenrus.org> <20080205154648.GA24331@elf.ucw.cz> <Pine.LNX.4.64.0802051648400.30955@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802051648400.30955@jikos.suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-02-05 16:49:04, Jiri Kosina wrote:
> On Tue, 5 Feb 2008, Pavel Machek wrote:
> 
> > uemacs ... broken with randomization
> > colums, sss ... local programs, broken with randomization
> > procinfo ... broken, randomization makes it die sooner.
> > mikmod ... broken with randomization
> > bsdsed ... broken with randomization
> > ...
> > Should I test few more?
> 
> Just to make things clear -- are all of these linked against the 1996 
> version of libc.so.5?

Yes.

root@amd:~# ls -al /lib/libc.so.5.4.33 
-rwxr-xr-x 1 root root 679259 Aug  2  1997 /lib/libc.so.5.4.33*

								Pavel

(Hmm... I should really cleanup my system:

pavel@amd:/usr/local/bin$ ./archie 
-sh: ./archie: cannot execute binary file
pavel@amd:/usr/local/bin$ file ./archie 
./archie: Linux/i386 demand-paged executable (QMAGIC))

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
