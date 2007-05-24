Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbXFANVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbXFANVn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 09:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757417AbXFANVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 09:21:21 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4805 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753128AbXFANVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 09:21:19 -0400
Date: Thu, 24 May 2007 14:40:28 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Crispin Cowan <crispin@novell.com>
Cc: Valdis.Kletnieks@vt.edu, Kyle Moffett <mrmacman_g4@mac.com>,
       Toshiharu Harada <haradats@gmail.com>, James Morris <jmorris@namei.org>,
       casey@schaufler-ca.com, Andreas Gruenbacher <agruen@suse.de>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
Message-ID: <20070524144028.GA3920@ucw.cz>
References: <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com> <Line.LNX.4.64.0705261442000.23020@d.namei> <9d732d950705261608j4bc72cd4s4378df9848101c84@mail.gmail.com> <EC769668-ED57-4D6D-80B2-1BFD039E113C@mac.com> <9d732d950705270025p1bedae23ne137f024eb78886f@mail.gmail.com> <4F828E03-DA6B-484E-A8F2-885D1BC6F23E@mac.com> <9d732d950705280341x78575d85kaf95b0e2884723f3@mail.gmail.com> <69A10107-78FE-4F11-AF52-9B8F648AFC0A@mac.com> <8219.1180473430@turing-police.cc.vt.edu> <465D111C.6060500@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <465D111C.6060500@novell.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Average users are not supposed to be writing security policy.  To be  
> >> honest, even average-level system administrators should not be  
> >> writing security policy.
> That explains so much! "SELinux: you're too dumb to use it, so just keep
> your hands in your pockets." :-)
> 
> AppArmor was designed to allow your average sys admin to write a
> security policy. It makes different design choices than SELinux to
> achieve that goal. As a result, AppArmor is an utter failure when
> compared to SELinux's goals, and SELinux in turn is an utter failure
> when compared to AppArmor's goals.

I'd not be that sure. SELinux can read AA config files, with some
performance problems and bad problems with new files.

I bet solving the 'new files' problem is not going to take 20% of AA's
size...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
