Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbZFIRDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbZFIRDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 13:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbZFIRCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 13:02:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:54661 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186AbZFIRCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 13:02:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 00/27] score arch files for linux
Date: Tue, 9 Jun 2009 19:00:31 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
References: <OF54D30DF0.6974DE98-ON482575D0.0021670B-482575D0.00234606@sunplusct.com>
In-Reply-To: <OF54D30DF0.6974DE98-ON482575D0.0021670B-482575D0.00234606@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906091900.32379.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/D0HoXYH5kKp2rwaAFhVfq2b4AWBf0dLx2pjm
 to6JRBI8ntsPMzcO+95BK9IholU0E79QkG+EWJhAZR26zCtzqc
 Nk+cHYtIhQ8XDpHzhMafVzVJ2I+AFc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009, liqin.chen@sunplusct.com wrote:
> Hi Arnd, Andrew Morton and linus,
> 
> According to your comment on score arch code, 
> we update score code base on asm-generic#next repository.
> use arch microblaze and blackfin as reference.
>

Some general notes about the patch submission, not the contents:
Your mail client still has a 'wordwrap' problem, which breaks
importing the patches into a repository. The easiest workaround
for this is to use 'git send-email', which handles it correctly.
Play around with the '--dry-run' and '--suppress-cc=all' options
at first to send the patches to yourself, so you know how it
works.

For 'git format-patch', please use the '-M -B --thread=shallow'
options so that all your mails end up nicely in a single mail
thread and renames are detected (the latter would not change
anything for your current set of patches, but may some day).

	Arnd <><
