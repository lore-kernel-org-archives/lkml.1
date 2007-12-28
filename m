Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbXL1DmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbXL1DmX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 22:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbXL1DmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 22:42:13 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:3820 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753482AbXL1DmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 22:42:12 -0500
Date: Fri, 28 Dec 2007 12:41:36 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Joe Perches <joe@perches.com>,
       Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] SH/Dreamcast - add support for GD-Rom device
Message-ID: <20071228034136.GA27806@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier@gentoo.org>, Joe Perches <joe@perches.com>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Jens Axboe <jens.axboe@oracle.com>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-sh <linux-sh@vger.kernel.org>
References: <1198774339.6170.11.camel@localhost.localdomain> <1198796281.4833.31.camel@localhost> <200712271949.02942.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712271949.02942.vapier@gentoo.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 27, 2007 at 07:49:01PM -0500, Mike Frysinger wrote:
> On Thursday 27 December 2007, Joe Perches wrote:
> > I also added a function gdrom_is_busy() to make a couple of tests
> > fit on a single line and perhaps easier to read.
> 
> i'd tend to agree it does make it easier to read, however you didnt make it 
> inline which means gcc may not inline it which means there's pointless 
> overhead of doing a function call.
> 
These days GCC is usually smart enough to automatically inline things
that are that small, it doesn't need to be explicitly labelled. If your
toolchain doesn't inline that gdrom_is_busy() implementation, get a
better toolchain.

> otherwise, arbitrary breaking on 80 cols actually makes the code harder to 
> read for no gain.

Hey now, some of us have no intention of giving up our 80x25 consoles,
not everyone buys in to this whole newfangled X thing. ;-)

More than 80 columns is generally fine so long as it's done so tastefully
rather than arbitrarily based on a larger console width. However, if it
can be split up cleanly for 80 columns, then it should be. ie, use common
sense, rather than blindly adhering to the whims of an anal-retentive
script.
