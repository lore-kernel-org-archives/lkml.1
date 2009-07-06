Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbZGFT5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbZGFT5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 15:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbZGFT5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 15:57:31 -0400
Received: from mail2.shareable.org ([80.68.89.115]:46296 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbZGFT5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 15:57:30 -0400
Date: Mon, 6 Jul 2009 20:57:20 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       Pavel Machek <pavel@ucw.cz>, tridge@samba.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090706195720.GB13638@shareable.org>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <200907012019.53932.rusty@rustcorp.com.au> <20090701122558.3a7c80d3@lxorguk.ukuu.org.uk> <20090701140503.GA21185@mit.edu> <20090701151727.38928bd9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701151727.38928bd9@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> From the funnies we've had in the past with FAT my gut impression is
> there are only a few implementations out there. Psion seems to have their
> own but most of the rest behave remarkably similarly which makes me
> suspect they all licensed a tiny number of implementations (DRDOS one
> perhaps ?). If we can keep most of those devices mounted 8.3 we nicely
> sidestep the issue anyway.

>From recently witnessing someone write another FAT implementation, for
an 8-bit AVR microcontroller reading SD cards, based in part on
someone elses public domain FAT implementation, fixing significant
bugs in that (including directory parsing), and then seeing it
translated from C to hand-coded AVR assembly language to save space,
with me helping teach C to the person doing it, for a commercial
product which is to be released in the next couple of months, and will
be updated with SD cards written by Linux and Windows...

>From witnessing that, for one obscure product among millions, I'd
guess there are more FAT implementations than a "few".  Perhaps there
aren't many VFAT implementations, but my gut says there are quite a
lot of independently written 8.3-only FAT ones.

-- Jamie
