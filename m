Return-Path: <linux-kernel-owner+w=401wt.eu-S1758745AbXETTz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745AbXETTz1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 15:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756117AbXETTzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 15:55:13 -0400
Received: from main.gmane.org ([80.91.229.2]:43948 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755773AbXETTzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 15:55:12 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: michael.mauch@gmx.de (Michael Mauch)
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Date: Sun, 20 May 2007 21:53:06 +0200
Organization: no
Message-ID: <2il6i4x7n3.ln2@elmicha.333200002251-0001.dialin.t-online.de>
References: <464F42F3.1080300@madrabbit.org> <2c0942db0705200910t777214efud489f4bc94433bf5@mail.gmail.com> <1179677799.3311.5.camel@lov.localdomain> <200705201829.19838.uwe.bugla@gmx.de>
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: pd9e8496f.dip.t-dialin.net
User-Agent: tin/1.8.3-20070201 ("Scotasay") (UNIX) (Linux/2.6.21-gentoo-r1 (i686))
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Uwe Bugla wrote:

> Andrey's path however (i. e. copying his attached version of loop.c into the 
> 2.6.22-rc2 kernel tree) led to:
> 
> a. an incompilable kernel
> b. endless messages trying to compile loop.c going like this (just a part of 
> them - not complete anyway!):
> 
> drivers/block/loop.c:1350: error: stray '\240' in program

That's the fault of one of your MUAs, that decided to convert a
normal space into a "no break space". With GNU sed you could use

  sed -i 's/\xa0/\x20/g' loop.c

to replace these back.

  Michael

