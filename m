Return-Path: <linux-kernel-owner+w=401wt.eu-S1758604AbXK3XH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604AbXK3XH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbXK3XHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:07:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60947 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169AbXK3XHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:07:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Sat, 1 Dec 2007 00:26:07 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Michael Cree <mcree@orcon.net.nz>, rct@gherkin.frus.com,
       linux-kernel@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       linux-scsi@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>
References: <20071126134819.8FE56DBA2@gherkin.frus.com> <47508EE9.9030304@orcon.net.nz> <20071130144250.e89335f3.akpm@linux-foundation.org>
In-Reply-To: <20071130144250.e89335f3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712010026.08086.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 30 of November 2007, Andrew Morton wrote:
> On Sat, 01 Dec 2007 11:30:01 +1300
> Michael Cree <mcree@orcon.net.nz> wrote:
> 
> > Bob Tracy wrote:
> > > Andrew Morton wrote:
> > >> Could be something change in sysfs.  Please double-check the config
> > >> options, make sure that something important didn't get disabled.
> > >>
> > >  Here's
> > > hoping someone else is seeing this or can replicate it in the meantime.
> > 
> > Snap.
> > 
> > 2.6.24-rc2 works fine.   2.6.24-rc3 boots on Alpha but once /dev is 
> > populated no partitions of the scsi sub-system are seen.  Looks like ide 
> > sub-system similarly affected.
> 
> Rafael, I assume you have this regression in the list?

Yes, http://bugzilla.kernel.org/show_bug.cgi?id=9457
