Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbZCZP5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbZCZP5f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 11:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZCZP51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 11:57:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753733AbZCZP50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 11:57:26 -0400
Date: Thu, 26 Mar 2009 08:47:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
Cc: mingo@elte.hu, tytso@mit.edu, jack@suse.cz, torvalds@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, a.p.zijlstra@chello.nl,
       npiggin@suse.de, jens.axboe@oracle.com, drees76@gmail.com,
       jesper@krogh.cc, linux-kernel@vger.kernel.org, oleg@redhat.com,
       roland@redhat.com
Subject: Re: relatime: update once per day patches (was: ext3 IO latency
 measurements)
Message-Id: <20090326084733.156c4910.akpm@linux-foundation.org>
In-Reply-To: <200903261632.42439.elendil@planet.nl>
References: <20090325123744.GK23439@duck.suse.cz>
	<20090325150041.GM32307@mit.edu>
	<alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
	<20090325185824.GO32307@mit.edu>
	<alpine.LFD.2.00.0903251341050.3032@localhost.localdomain>
	<20090325215137.GQ32307@mit.edu>
	<alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
	<20090325235041.GA11024@duck.suse.cz>
	<20090326090630.GA9369@elte.hu>
	<20090326113705.GV32307@mit.edu>
	<20090326140312.GB14822@elte.hu>
	<20090326140312.GB14822@elte.hu>
	<20090326073013.2fa83178.akpm@linux-foundation.org>
	<200903261632.42439.elendil@planet.nl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 16:32:38 +0100 Frans Pop <elendil@planet.nl> wrote:

> Andrew Morton wrote:
> > On Thu, 26 Mar 2009 15:03:12 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> >> Why arent the relatime patches upstream?
> > 
> > They have been for ages.
> 
> I assume Ingo means the patches to make relatime update atime at least 
> once per day to ensure better compatibility with apps that do use or rely 
> on access times.
> These patches are already being included by several distros and, FWIW, 
> Debian would like to see them upstream as well because we feel .
> 
> They were last submitted by Matthew Garrett:
> http://lkml.org/lkml/2008/11/27/234
> http://lkml.org/lkml/2008/11/27/235
> 
> Loads of people seem to want this, but even though it's been submitted at 
> least twice and discussed even more often, it never gets anywhere.
> 

Hard-wiring a 24-hour interval into the core VFS for all mounted
filesystems is dumb.

I (and others) pointed out that it would be better to implement this as
a mount option.  That suggestion was met with varying sillinesses and
that is where things stand.
