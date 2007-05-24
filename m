Return-Path: <linux-kernel-owner+w=401wt.eu-S1754189AbXEXV3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbXEXV3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbXEXV3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:29:04 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:42037 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbXEXV3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:29:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qo50LDJ3N8kjwf4hOc7Q3/13r8iy9VdV2otQeB9oguLjW4s2Tsn4VOL6FXW4N6ELHJLJE+GM5ik/uhhvsm3eMa3ToT4+Dk52yV1eXeoTlLxoJdsGYu8IpvkZWwNxntJTtTnxQLFeQMFR8ZcpT+neQxx1sWAAubVBBSzqIUc5RoM=
Subject: Re: Long delay in resume from RAM (Was Re: [patch 00/69]
	-stablereview)
From: Romano Giannetti <romano.giannetti@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20070524140154.c8e93d69.akpm@linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org>
	 <4652070D.3090509@redhat.com>
	 <alpine.LFD.0.98.0705211406000.3890@woody.linux-foundation.org>
	 <20070521212522.GL3429@sequoia.sous-sol.org>
	 <1179870110.16656.2.camel@localhost>
	 <alpine.LFD.0.98.0705221452290.3890@woody.linux-foundation.org>
	 <1180008394.15600.26.camel@localhost> <1180019201.15600.57.camel@localhost>
	 <alpine.LFD.0.98.0705240815530.26602@woody.linux-foundation.org>
	 <1180037649.15241.6.camel@localhost>
	 <20070524140154.c8e93d69.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 24 May 2007 23:28:33 +0200
Message-Id: <1180042113.15241.17.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-24 at 14:01 -0700, Andrew Morton wrote:
> On Thu, 24 May 2007 22:14:08 +0200
> Romano Giannetti <romano.giannetti@gmail.com> wrote:
> 

> ntfs is being naughty.
> 

> hm, lots of Makefiles commit the same sin.  Sam, is this as busted as
> I think it is?

Hmmm... 

CC [M]  drivers/ide/pci/amd74xx.o
drivers/ide/pci/amd74xx.c:28:24: error: ide-timing.h: No such file or
directory
(etc etc)

... and in Makefile:

EXTRA_CFLAGS    := -Idrivers/ide

I changed it to 

EXTRA_CFLAGS    += -Idrivers/ide

but I have the same error. Puzzled (yes, again).






