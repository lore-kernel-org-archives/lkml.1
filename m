Return-Path: <linux-kernel-owner+w=401wt.eu-S1760347AbXGEOHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760347AbXGEOHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757070AbXGEOG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:06:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53749 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757322AbXGEOG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:06:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 16:14:17 +0200
User-Agent: KMail/1.9.5
Cc: pavel@ucw.cz, oliver@neukum.org, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707051531.37532.rjw@sisk.pl> <E1I6RjE-0000pP-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I6RjE-0000pP-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051614.19300.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 15:50, Miklos Szeredi wrote:
> > > > Don't you think, however, that it can be modified a little to play well,
> > > > for example, with the freezer?
> > > 
> > > I could stick a couple of try_to_freeze()s into fuse, and that would
> > > make suspend failure less likely.  But making problems less easy to
> > > reproduce is not a good thing.
> > 
> > So, how about eliminating them?
> 
> That can't be done just within fuse, a process might be sleeping on a
> VFS mutex.  Do we want to hack VFS as well?

No.

> I guess I know your answer.  But it ain't gonna work.  Suspend code
> really doesn't belong in VFS, and I'm pretty sure the maintainers of
> that little piece of code would agree with me on this.

Surprise, surprise.  Not that I'm scared of the VFS maintainers, though. ;-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
