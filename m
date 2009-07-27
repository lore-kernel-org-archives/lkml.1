Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbZG0W1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbZG0W1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbZG0W1C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:27:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36989 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbZG0W1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:27:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [Bug #13730] hitting lockdep limits...
Date: Tue, 28 Jul 2009 00:27:38 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <1248675700.6987.1416.camel@twins> <6278d2220907270207g7ff93fd1kdf59e32f139269d3@mail.gmail.com>
In-Reply-To: <6278d2220907270207g7ff93fd1kdf59e32f139269d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907280027.39339.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, Daniel J Blueman wrote:
> On Mon, Jul 27, 2009 at 7:21 AM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> > On Sun, 2009-07-26 at 22:28 +0200, Rafael J. Wysocki wrote:
> >> This message has been generated automatically as a part of a report
> >> of recent regressions.
> >>
> >> The following bug entry is on the current list of known regressions
> >> from 2.6.30.  Please verify if it still should be listed and let me know
> >> (either way).
> >>
> >>
> >> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13730
> >> Subject               : hitting lockdep limits...
> >> Submitter     : Daniel J Blueman <daniel.blueman@gmail.com>
> >> Date          : 2009-07-05 18:19 (22 days old)
> >> References    : http://marc.info/?l=linux-kernel&m=124681799023782&w=4
> >>
> >
> >
> > Is this still a problem after?
> >
> > commit b0a5b83ee0fce9dbf8ff5fe1f8c9ae7dfafe458c
> > Author: Ingo Molnar <mingo@elte.hu>
> > Date:   Tue Jun 16 16:11:14 2009 +0200
> >
> >    dma-debug: Put all hash-chain locks into the same lock class
> 
> Using the same .config and use profile, I haven't seen this in
> 2.6.31-rc4, thus this can be closed. I've updated the kernel bugzilla
> entry also.

Thanks, closed.

Rafael
