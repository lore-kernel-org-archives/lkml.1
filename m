Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbZJRW4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbZJRW4j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbZJRW4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:56:38 -0400
Received: from foo.birdnet.se ([213.88.146.6]:40445 "HELO foo.birdnet.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752290AbZJRW4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:56:37 -0400
Message-ID: <20091018225641.20994.qmail@stuge.se>
Date: Mon, 19 Oct 2009 00:56:41 +0200
From: Peter Stuge <peter@stuge.se>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Adding an ioctl or three
Mail-Followup-To: Randy Dunlap <rdunlap@xenotime.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <20091015205803.30544.qmail@stuge.se> <20091015223137.6b9fb55a@lxorguk.ukuu.org.uk> <20091015214642.6208.qmail@stuge.se> <20091015230853.44fb10c1@lxorguk.ukuu.org.uk> <20091018162737.18611.qmail@stuge.se> <20091018223306.17571.qmail@stuge.se> <20091018153942.aeef78ee.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091018153942.aeef78ee.rdunlap@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> > Documentation/ioctl/ioctl-number.txt seems out of date. I picked
> > a number that was used (by linux/toshiba.h) but not listed. Do I
> > have to grep it out?
> 
> Can you at least list what files/drivers need to be added to
> Documentation/ioctl/ioctl-number.txt, please?

Linus' include/linux/toshiba.h has a single ioctl:

#define TOSH_SMM _IOWR('t', 0x90, int)  /* broken: meant 24 bytes */

Maybe I picked the only unlisted number? :)


//Peter
