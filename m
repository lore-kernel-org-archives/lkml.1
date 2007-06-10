Return-Path: <linux-kernel-owner+w=401wt.eu-S1761417AbXFJVGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761417AbXFJVGT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 17:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbXFJVGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 17:06:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47028 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751637AbXFJVGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 17:06:03 -0400
Date: Sun, 10 Jun 2007 23:05:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070610210547.GC25138@elf.ucw.cz>
References: <20070514110607.549397248@suse.de> <200706042303.28785.agruen@suse.de> <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm> <20070610083427.GA24808@elf.ucw.cz> <Pine.LNX.4.64.0706100201540.6675@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706100201540.6675@asgard.lang.hm>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >>extended out this can come close to giving each file it's own label. AA
> >>essentially does this and calls the label the path and computes it at
> >>runtime instead of storing it somewhere.
> >
> >Yes, and in the process, AA stores compiled regular expressions in
> >kernel. Ouch. I'll take "each file it's own label" over _that_ any time.
> 
> and if each file has it's own label you are going to need regex or similar 
> to deal with them as well.

But you have that regex in _user_ space, in a place where policy
is loaded into kernel.

AA has regex parser in _kernel_ space, which is very wrong.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
