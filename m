Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbZFIQjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbZFIQjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757513AbZFIQjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:39:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54002 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149AbZFIQjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:39:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 0/14] score - New architecure port to SunplusCT S+CORE
Date: Tue, 9 Jun 2009 18:37:28 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-arch@vger.kernel.org,
       linux-arch-owner@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org
References: <OF47CBE0C5.C2291ED8-ON482575CF.00287989-482575CF.0028F312@sunplusct.com>
In-Reply-To: <OF47CBE0C5.C2291ED8-ON482575CF.00287989-482575CF.0028F312@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?iso-8859-1?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-1?q?Y=2Ea=5E3zb?=)
 =?iso-8859-1?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-1?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906091837.28897.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19SOOVLvxgWYNV+bPjS17WRp9rNDNRSNzbA7Jv
 im7OdYcvtSQCGalqTXdOBPTe444dw8VjOKnkm1DbfURX8Si7YT
 dIXCjEHn9o30fy+DqDc6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 June 2009, liqin.chen@sunplusct.com wrote:
> Thanks Arnd, our MIS help me solve the download problem.
> 
> > Feel free to base you code on top of asm-generic.git#next, but tell me
> > when you intend to do that so I can warn you of possibly rebases.
> 
> Last week, I had updated score code base on asm-generic.git#next.
> 
> and I will apply a account on kernel.org, But before I get the account,
> can you let score code merge in asm-generic.git?

I can take your patches and apply them to a new branch in my tree
if that helps. I hope that Linus can pull my tree early in the
merge window so your architecture port and the microblaze changes
based on it can also get in soon.

I guess for the new architecture, it makes sense to combine all
your patches into a single changeset in git, since they don't
make sense until you have the complete set, and your changeset
comments are rather boring so far anyway.

Can you write a few paragraphs of text about your architecture
for the initial changeset comment? I think it would be good
to permanently store some facts in there, e.g. in which ways
the architecture is different from others, where to get a
toolchain and what kinds of hardware exist for it.

I'll go through the patches once more and see if I find anything
that should still be changed before the code goes in, but
from a brief look, the code looks pretty good now.

	Arnd <><
