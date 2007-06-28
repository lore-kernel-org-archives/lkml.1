Return-Path: <linux-kernel-owner+w=401wt.eu-S1764951AbXF1WBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764951AbXF1WBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761387AbXF1WA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:00:59 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52740 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758062AbXF1WA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:00:57 -0400
Date: Fri, 29 Jun 2007 00:00:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Chinner <dgc@sgi.com>, linux-pm <linux-pm@lists.osdl.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, LinuxRaid <linux-raid@vger.kernel.org>,
       LVM general discussion and development 
	<linux-lvm@redhat.com>,
       David Robinson <zxvdr.au@gmail.com>, David Greaves <david@dgreaves.com>
Subject: Re: [linux-pm] Re: [linux-lvm] 2.6.22-rc4 XFS fails after hibernate/resume
Message-ID: <20070628220045.GA4521@elf.ucw.cz>
References: <46744065.6060605@dgreaves.com> <20070618145007.GE85884050@sgi.com> <20070627204924.GA4777@ucw.cz> <200706281727.35430.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706281727.35430.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2007-06-28 17:27:34, Rafael J. Wysocki wrote:
> On Wednesday, 27 June 2007 22:49, Pavel Machek wrote:
> > Hi!
> > 
> > > FWIW, I'm on record stating that "sync" is not sufficient to quiesce an XFS
> > > filesystem for a suspend/resume to work safely and have argued that the only
> > 
> > Hmm, so XFS writes to disk even when its threads are frozen?
> > 
> > > safe thing to do is freeze the filesystem before suspend and thaw it after
> > > resume. This is why I originally asked you to test that with the other problem
> > 
> > Could you add that to the XFS threads if it is really required? They
> > do know that they are being frozen for suspend.
> 
> Well, do you remember the workqueues?  They are still nonfreezable.

Oops, that would explain it :-(. Can we make XFS stop using them?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
