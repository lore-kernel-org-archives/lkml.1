Return-Path: <linux-kernel-owner+w=401wt.eu-S1753032AbYCPT07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbYCPT07 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 15:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYCPT0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 15:26:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36987 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbYCPT0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 15:26:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [possible regression] 2.6.22 reiserfs/libata sporadically hangs on resume from hibernation
Date: Sun, 16 Mar 2008 20:25:35 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200706300859.47133.arvidjaar@mail.ru> <200803132146.42156.rjw@sisk.pl> <200803162204.44131.arvidjaar@mail.ru>
In-Reply-To: <200803162204.44131.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803162025.35558.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 16 of March 2008, Andrey Borzenkov wrote:
> On Thursday 13 March 2008, Rafael J. Wysocki wrote:
> > On Thursday, 13 of March 2008, Andrey Borzenkov wrote:
> > > 
> > > For the record - it happened again under 2.6.25-rc5; it reall drives
> > > me nuts. Of course every time it happens I do not have infrastructure to use
> > > netconsole :( I am about to reformat the whole with ext3 as this seems
> > > to always hang somewhere in fs access and looks like not many people
> > > use reiser today.
> > >
> > 
> > Well, it may be related to having the root partition on reiserfs.  I've never
> > seen anything like this with non-root reiserfs partitions ...
> > 
> 
> This one looks the hell similar to what I posted and Ingo is using ext3 ...
> 
> http://marc.info/?l=linux-kernel&m=120479427912295&w=2

Hm, this is not related to hibernation.

Perhaps hibernation just makes it easier to trigger the bug.

There's entire thread related to this problem, please have a look at it:
http://lkml.org/lkml/2008/3/16/55

Thanks,
Rafael
