Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbYDBR4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbYDBR4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756435AbYDBR4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:56:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54025 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385AbYDBR43 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:56:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: 2.6.25-rc6 hangs at resume after suspend to RAM on Mac mini Core Duo
Date: Wed, 2 Apr 2008 19:56:21 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Tino Keitel <tino.keitel@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Felix =?iso-8859-15?q?M=F6ller?= <felix@derklecks.de>
References: <20080320060550.GA13200@dose.home.local> <200804012305.04250.rjw@sisk.pl> <1207157629.9669.2.camel@localhost>
In-Reply-To: <1207157629.9669.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804021956.22180.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 2 of April 2008, Soeren Sonnenburg wrote:
> On Tue, 2008-04-01 at 23:05 +0200, Rafael J. Wysocki wrote:
> > On Tuesday, 1 of April 2008, Soeren Sonnenburg wrote:
> > > On Tue, 2008-04-01 at 08:27 +0200, Tino Keitel wrote:
> > > > On Tue, Apr 01, 2008 at 06:23:11 +0000, Soeren Sonnenburg wrote:
> > > > > On Mon, 2008-03-31 at 23:28 +0200, Tino Keitel wrote:
> > > > > > On Sat, Mar 29, 2008 at 00:03:15 +0100, Rafael J. Wysocki wrote:
> > > > > > 
> > > > > > [...]
> > > > > > 
> > > > > > > Can you please try to boot with acpi_new_pts_ordering and retest?
> > > > > > 
> > > > > > I just tried current -git (a9edadbf790d72adf6ebed476cb5caf7743e7e4a),
> > > > > > without success. I still got the same hand at resume.
> > > > > 
> > > > > I am having the hang on resume problem too (macbook pro), cf.
> > > > > http://bugzilla.kernel.org/show_bug.cgi?id=10319, 2.6.24 was fine.
> > > > 
> > > > What about 2.6.25-rc5? Up to this, resume works for me. -rc6 is broken.
> > > 
> > > No never worked in 2.6.25 (at least from rc2 on) and still does not in
> > > rc7-current-git. But note that on console I could suspend to ram and
> > > resume but the display is not anymore coming back with s2ram - from
> > > within X it freezes though.
> > 
> > Please try -rc8.
> 
> OK I did. Now not only the console stays black but blindly typing
> reboot/s2ram does not do anything after a resume... in this respect rc7
> was better though not usable (as the display remained off).

The Felix's MacBook suspends sucessfully with current -git, AFAICS.  Perhaps
you can compare .configs?

Rafael
