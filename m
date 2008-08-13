Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbYHMK2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbYHMK2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 06:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYHMK2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 06:28:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47820 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbYHMK2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 06:28:04 -0400
Date: Wed, 13 Aug 2008 12:28:02 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Press, Jonathan" <Jonathan.Press@ca.com>
Cc: davecb@sun.com, Arjan van de Ven <arjan@infradead.org>,
       Mihai Don??u <mdontu@bitdefender.com>, Adrian Bunk <bunk@kernel.org>,
       tvrtko.ursulin@sophos.com, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Message-ID: <20080813102802.GC27074@atrey.karlin.mff.cuni.cz>
References: <20080806105008.GF6477@cs181140183.pp.htv.fi> <200808070349.55882.mdontu@bitdefender.com> <20080806213904.37a33a58@infradead.org> <200808111645.48177.mdontu@bitdefender.com> <20080811065608.44687f65@infradead.org> <48A0649B.4010706@sun.com> <2629CC4E1D22A64593B02C43E855530304AE4B80@USILMS12.ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2629CC4E1D22A64593B02C43E855530304AE4B80@USILMS12.ca.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >   Perhaps I could try: the AV folks are trying to prevent the
> > execution of either modified normal binaries/files or
> > specifically exploit binaries/files, by machines for which the
> > files are executable or interpretable.
> > 
> >   The experience of those communities is predominantly
> > with DOS/Windows executables and interpretable files, which
> > they have difficulty generalizing from.
> > 
> >   In principle, they could be targeted at any machine, so any
> > mechanisms should be applicable to native executables and
> > interpretables as well as foreign ones.
> 
> 
> You know, that's actually a very good statement of the model.
> 
> I think everyone understands one side of the threat model, that is Linux machines being carriers of infections aimed at other platforms.  There are many ways that such infections can be stored, and many ways in which they can be communicated to the target machines.  There are so many that it would not be effective or efficient for each such transfer application to be able to handle its own malware scanning, which is the short statement of why centralized AV protection with notification assistance from the kernel is appropriate.
> 

No.

Proposed kernel solution did not work -- there still was write
vs. read race. You are right that it is not ok for each application to
do its own malware scanning, but libmalware.so that handles the
scanning seems very reasonable.

And as applications _need_ to be modified for the write vs. read race
to be solved, libmalware.so looks like a way forward.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
