Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbYFWPQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbYFWPQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 11:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbYFWPQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 11:16:14 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50040 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755229AbYFWPQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 11:16:13 -0400
Date: Mon, 23 Jun 2008 18:14:17 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Bob Peterson <rpeterso@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cluster-devel@redhat.com,
       Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [Cluster-devel] Re: [Bug 10827] 2.6.26rc4 GFS2 oops.
Message-ID: <20080623151417.GA28779@cs181140183.pp.htv.fi>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <Jn7irxIunJK.A.nME.ZJDVIB@albercik> <20080622090906.GD27069@cs181133002.pp.htv.fi> <1214232039.3724.66.camel@technetium.msp.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1214232039.3724.66.camel@technetium.msp.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 09:40:39AM -0500, Bob Peterson wrote:
> On Sun, 2008-06-22 at 12:09 +0300, Adrian Bunk wrote:
> > On Sat, Jun 14, 2008 at 10:12:03PM +0200, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.25.  Please verify if it still should be listed.
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10827
> > > Subject		: 2.6.26rc4 GFS2 oops.
> > > Submitter	: Dave Jones <davej@redhat.com>
> > > Date		: 2008-05-27 15:44 (19 days old)
> > > References	: http://lkml.org/lkml/2008/5/27/297
> > 
> > Dave, what is the status of this bug?
> > 
> > It's currently listed as a 2.6.26-rc regression.
> > 
> > Is it actually confirmed that 2.6.25 is fine?
> > 
> > According to the thread of the bug report there should now be a bug 
> > report in the Red Hat Bugzilla for it. Bug number?
> > 
> > Thanks
> > Adrian
> 
> Hi,
> 
> This appears to be a known bug.  There's a Fedora bugzilla record for
> it here, which contains a patch to fix the problem:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=448866

Thanks for the pointer.

> The bug does not appear to be in 2.6.25; 2.6.25 is fine afaict.

Yup, the patch in your Bugzilla is for code that is new in 2.6.26.

Can you push your patch for inclusion into 2.6.26 so that 2.6.26 won't 
get released with this regression?

> Regards,
> 
> Bob Peterson
> Red Hat GFS

Thanks
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

