Return-Path: <linux-kernel-owner+w=401wt.eu-S1759053AbXHBTcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053AbXHBTcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbXHBTcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:32:41 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45679 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753518AbXHBTck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:32:40 -0400
Date: Thu, 2 Aug 2007 21:31:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, Jan Blunck <jblunck@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Re: [RFC 12/26] ext2 white-out support
Message-ID: <20070802193159.GA23149@elf.ucw.cz>
References: <20070730161323.100048969@weierstrass.suse.de> <20070730161324.261652101@weierstrass.suse.de> <20070731034515.GD25876@thunk.org> <20070731074436.GE5101@hasse.suse.de> <20070731105309.GA6980@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731105309.GA6980@thunk.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I wouldn't bother with setting the directory type field to be DT_WHT,
> > > given that they will never be returned to userspace anyway.
> > 
> > At the moment I still rely on this for the current readdir implementation.
> > Viro already said that he doesn't want to see this (the readdir changes) in
> > the kernel but in userspace.
> 
> Life gets very messy if you have to do this in userspace.  Example:
> statically linked programs that were compiled with a version of glibc
> that didn't know about whiteout records.  Unfortunately, the memory

WEll, also if root deletes something, it should be _gone_, and user
should not be able to work around that just by bringing statically
linked ls..
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
