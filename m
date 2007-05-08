Return-Path: <linux-kernel-owner+w=401wt.eu-S1031452AbXEHTP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031452AbXEHTP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031400AbXEHTPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:15:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44358 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031385AbXEHTPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:15:49 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Miles Lane" <miles.lane@gmail.com>
Subject: Re: [linux-pm] 2.6.21 -- Forced to hard power off from attempted hibernation
Date: Tue, 8 May 2007 21:20:40 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <a44ae5cd0705080009l2e7bac9ayc379acdfe17e2507@mail.gmail.com> <200705081224.48600.rjw@sisk.pl> <a44ae5cd0705080927v2203543dl7fcee33c139cc4c0@mail.gmail.com>
In-Reply-To: <a44ae5cd0705080927v2203543dl7fcee33c139cc4c0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705082120.40508.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 8 May 2007 18:27, Miles Lane wrote:
> On 5/8/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > Hi,
> >
> > On Tuesday, 8 May 2007 09:09, Miles Lane wrote:
> > > Hello,
> > >
> > > When I tried to hibernate my laptop (HP Pavilion dv1240us), everything
> > > seemed to be working,  but the power never shut off.  I had to hold
> > > down the power button for five seconds.
> >
> > Does the log below finish where the machine hanged?
> 
> It's odd.  I thought that the hang must have occurred down...
> 
> > > [ 2815.639718] pci 0000:00:00.1: LATE freeze
> > > [ 2815.639718] agpgart-intel 0000:00:00.0: LATE freeze
> > > [ 2815.639718] swsusp: critical section:
> > > [ 2815.639718] swsusp: Need to copy 124696 pages
> > > [ 2815.639718] swsusp: Normal pages needed: 114475 + 1024 + 24,
> > > available pages: 118745
> 
> <<< HERE >>>
> 
> > > [ 2815.639718] Intel machine check architecture supported.
> > > [ 2815.639718] Intel machine check reporting enabled on CPU#0.
> > > [ 2815.639718] agpgart-intel 0000:00:00.0: EARLY resume
> 
> Since this is where the suspend process seems to complete and the
> resume begins.

Does this mean that it hanged during the resume?

Rafael

PS
Please keep the CC list when you reply, thanks.
