Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbXFJIfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbXFJIfI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 04:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762696AbXFJIey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 04:34:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56229 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759151AbXFJIex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 04:34:53 -0400
Date: Sun, 10 Jun 2007 10:34:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070610083427.GA24808@elf.ucw.cz>
References: <20070514110607.549397248@suse.de> <200706042303.28785.agruen@suse.de> <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706081757070.18969@asgard.lang.hm>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >So, AA developers, do you have such a document anywhere?  I know there
> >are some old research papers, do they properly describe the current
> >model you are trying to implement here?
> 
> Greg,
>   to implement the AA approach useing SELinux you need to have a way that 
> files that are renamed or created get tagged with the right label 
> automaticaly with no possible race condition.
> 
> If this can be done then it _may_ be possible to do the job that AA is 
> aimed at with SELinux, but the work nessasary to figure out what lables 
> are needed on what file would still make it a non-trivial task.
> 
> as I understand it SELinux puts one label on each file, so if you have 
> three files accessed by two programs such that
> program A accesses files X Y
> program B accesses files Y Z
> 
> then files X Y and Z all need seperate labels with the policy stateing 
> that program A need to access labels X, Y and program B needs to access 
> files Y Z
> 
> extended out this can come close to giving each file it's own label. AA 
> essentially does this and calls the label the path and computes it at 
> runtime instead of storing it somewhere.

Yes, and in the process, AA stores compiled regular expressions in
kernel. Ouch. I'll take "each file it's own label" over _that_ any time. 
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
