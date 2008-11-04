Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYKDVEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYKDVEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 16:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbYKDVEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 16:04:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48881 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767AbYKDVEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 16:04:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: [git patches] libata hibernation fixes
Date: Tue, 4 Nov 2008 22:08:42 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
References: <20081104062734.GA4420@havoc.gtf.org> <alpine.LFD.2.00.0811040823350.3419@nehalem.linux-foundation.org> <20081104203036.GE5862@ucw.cz>
In-Reply-To: <20081104203036.GE5862@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811042208.42982.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 4 of November 2008, Pavel Machek wrote:
> Hi!
> 
> >  - quite possibly: we just should not spin down disks at all, and just 
> >    flush them and do the "park" command thing. If we're _really_ powering 
> >    off, the disks will spin down on their own when power goes away. Maybe 
> >    that's what Windows does?
> 
> I believe that 'emergency' spindown (on power fail) is different from
> regular spindown, and that emergency spindown damages the disk more.
> 
> But perhaps park + power fail is similar to regular spindown?
> 
> (Is park command normally supported on modern disks? IIRC hdaps people
> had issues with not all disks supporting it?)

I don't know really and that's why I'd prefer it if Tejun commented here.

Anyway, I created these patches because the people who discussed this issue
believed it was the right thing to do.  They are based on a Tejun's patch
posted as an attachment to http://bugzilla.kernel.org/show_bug.cgi?id=8855 .
Please look into that bug entry for further references.

Thanks,
Rafael
