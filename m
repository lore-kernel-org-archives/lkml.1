Return-Path: <linux-kernel-owner+w=401wt.eu-S1755287AbZJJHaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbZJJHaf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 03:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbZJJHad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 03:30:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:54404 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754850AbZJJHad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 03:30:33 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX18PXmEunMsPQjdgSZBhl93xF2DYesaBHqxIUMii4B
	kFwJpt6JugBz98
Subject: Re: ext4 corruptions
From: Alexey Fisher <bug-track@fisher-privat.net>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Alexey Fisher <bug-track@fisher-privat.net>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
       Andreas Dilger <adilger@sun.com>
In-Reply-To: <4ACFB337.8040109@redhat.com>
References: <1255116014.3014.8.camel@mini>
	 <alpine.LRH.2.00.0910092351140.12171@twin.jikos.cz>
	 <4ACFB337.8040109@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Oct 2009 09:29:44 +0200
Message-Id: <1255159784.27545.4.camel@zwerg>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 09.10.2009, 17:03 -0500 schrieb Eric Sandeen:
> Jiri Kosina wrote:
> > [ adding some CCs so that this doesn't get lost in the lkml wilderness ]
> > 
> > On Fri, 9 Oct 2009, Alexey Fisher wrote:
> > 
> >> I have really bad ext4 corruptions, i needed to reinstall 3 of my test
> >> systems.
> >> The symptoms:
> >> is use karmic beta for this with ubuntu supplied kernel 2.6.31 ... after
> >> testing 2.6.32-rc[1-3] and booting again to 2.6.31 fsck will find some
> >> bad things and will try to fix it. After this action is the system
> >> unusable.
> > 
> > Does this happen also when you switch from vanilla 2.6.32-rcX to vanilla 
> > 2.6.31, or only from vanilla 2.6.32-rcX to "Ubuntu 2.6.31"?
> > 
> >> Do any one had same problem? The is no sans to bisect it, after some
> >> jumps between 2.6.31 and 2.6.32 the system will be broken.  Is it kernel
> >> or fsck problem?
> > 
> 
> Not sure if this is the same as
> http://bugzilla.kernel.org/show_bug.cgi?id=14354 but it's similarly
> lacking in useful info ;)
> 
> Please provide the fsck output, any kernel messages, etc ...
> 
> -Eric

Thank you for the tip. These systems i need for testing graphic
regressions, so i'll try reproduce it on virtual system.

Alexey

