Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbZGBBnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbZGBBnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 21:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbZGBBnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 21:43:04 -0400
Received: from mail.samba.org ([66.70.73.150]:52140 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbZGBBnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 21:43:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19020.4239.587690.363822@samba.org>
Date: Thu, 2 Jul 2009 11:42:39 +1000
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
In-Reply-To: <20090701151727.38928bd9@lxorguk.ukuu.org.uk>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
	<20090701140503.GA21185@mit.edu>
	<20090701151727.38928bd9@lxorguk.ukuu.org.uk>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

 > > There really was no such thing as "vfat" anyway.  VFAT in the Windows
 > 
 > In the eyes of the end user there is such a thing as vfat. This is about
 > expectations not technical issues.

Do you have an example of an end user device that would be affected by
this change, and which is never distributed in any of the countries
where a varient of this patent exists?

 > From the funnies we've had in the past with FAT my gut impression is
 > there are only a few implementations out there. Psion seems to have their
 > own but most of the rest behave remarkably similarly which makes me
 > suspect they all licensed a tiny number of implementations (DRDOS one
 > perhaps ?).

Do you happen to have a Psion and/or DRDOS based device in your
collection of toys so you can test with the proposed patch and see if
there are any problems?

Apart from Windows varients and MacOSX I have also tested on the
following mobile phones (via a microSD card):

  Samsumg SGH-E250
  Nokia 6120

They both worked fine with long filename images saved on a Linux
system with this patch. I don't know what OSes these phones are based
on.

Maybe you could test on the various devices with removable media you
have and see how it goes?

Cheers, Tridge
