Return-Path: <linux-kernel-owner+w=401wt.eu-S933381AbYEBAOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381AbYEBAOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755208AbYEBAOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:14:08 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:49040 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbYEBAOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:14:07 -0400
Date: Thu, 1 May 2008 17:12:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Ryan Roth <ryanroth@sbcglobal.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ryan.Roth@CH2M.com,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 10586] New: High Number of Segfaults
 onMacBookStarting With 2.6.24.5 Kernel
Message-Id: <20080501171231.6248b7c0.randy.dunlap@oracle.com>
In-Reply-To: <481A5A94.2080400@sbcglobal.net>
References: <bug-10586-10286@http.bugzilla.kernel.org/>
	<20080501130444.cc5c63e8.akpm@linux-foundation.org>
	<86A21F45FFA48B408A65E67054362EB6069DD742@CULEBRA.amr.ch2m.com>
	<20080501133003.be723364.akpm@linux-foundation.org>
	<86A21F45FFA48B408A65E67054362EB621C948@CULEBRA.amr.ch2m.com>
	<481A5276.4040607@sbcglobal.net>
	<20080501170239.9b740877.akpm@linux-foundation.org>
	<481A5A94.2080400@sbcglobal.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 May 2008 17:04:36 -0700 Ryan Roth wrote:

> Andrew Morton wrote:
> > On Thu, 01 May 2008 16:29:58 -0700
> > Ryan Roth <ryanroth@sbcglobal.net> wrote:
> >
> >   
> >>> OK, worried.  This is a huge bug.  But afaik you're the only person 
> >>> who has
> >>> hit it, so there must be something special in your setup which is
> >>> triggering it.  This could be hard.
> >>>
> >>>       
> >> OK here is what I get with the git16 kernel.  On boot I get this error:
> >>
> >> PCI: Not using MMCONFIG
> >> PCI: BIOS Bug: MCFG area at f0000000 is not reserved in ACPI motherboard 
> >> resources
> >> PCI: Not using MMCONFIG
> >>     
> >
> > yeah, mmconfig is a problem.  It should be harmless.  Probably you're
> > better off with it disabled ;)
> >
> >   
> >> Attached is a complete log after this boot
> >>     
> >
> > I see no 'segfault' messages in there?
> >
> >   
> Since this last boot I have only got these:
> 
> > May 1 16:26:25 kernel: gnome-power-man[3112]: segfault at 0 ip 410fda 
> > sp 7fff4712c870 error 4 in gnome-power-manager[400000+47000]
> > May 1 16:26:25 kernel: gnome-power-man[3116]: segfault at 0 ip 410fda 
> > sp 7fff2959cce0 error 4 in gnome-power-manager[400000+47000]
> > May 1 16:26:25 kernel: gnome-power-man[3119]: segfault at 0 ip 410fda 
> > sp 7fffc7671db0 error 4 in gnome-power-manager[400000+47000]

Are you using stack protector?  How could we tell?
I don't see it in the kernel log.

Also, please post your kernel .config file.

---
~Randy
