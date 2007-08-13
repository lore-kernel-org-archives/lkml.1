Return-Path: <linux-kernel-owner+w=401wt.eu-S1761122AbXHMUBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761122AbXHMUBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbXHMUBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:01:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42709 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754582AbXHMUBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:01:12 -0400
Date: Mon, 13 Aug 2007 21:55:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: resume from ram much slower
Message-ID: <20070813195507.GB18731@elf.ucw.cz>
References: <200708101848.37222.arekm@maven.pl> <6bffcb0e0708101034x44ef5bd0we6a94e398c30c511@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0708101034x44ef5bd0we6a94e398c30c511@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> [S-T-R wizards CC'ed]
> 
> On 10/08/07, Arkadiusz Miskiewicz <arekm@maven.pl> wrote:
> > Hi,
> >
> > Starting 1-2 weeks ago I have very long resume from
> > ram times. It takes more than 1 min to resume. Does anyone see such behaviour?
> >
> > Kernel from yesterday git, thinkpad z60m, suspend.sf.net tools 20070801
> >
> > "ACPI handle has no context!" are interesting btw.


Usual way to debug it is to unload as many modules as possible, to
find out if it is caused by one of them...

If that does not help, you can try playing with git to find out which
commit caused the regression.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
