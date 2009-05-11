Return-Path: <linux-kernel-owner+w=401wt.eu-S1759040AbZEKSlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040AbZEKSlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZEKSlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:41:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49323 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752573AbZEKSlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:41:13 -0400
Date: Mon, 11 May 2009 19:40:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090511194026.79ecd3aa@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2510905111104g5ce4e8e6xf8b4de41454c3d2f@mail.gmail.com>
References: <20090509143742.GA27663@kroah.com>
	<20090511115504.568c9a92@lxorguk.ukuu.org.uk>
	<ac3eb2510905110434nb123423m134e848c17c3c736@mail.gmail.com>
	<20090511141057.24a5f8ed@lxorguk.ukuu.org.uk>
	<ac3eb2510905110714m5877da13q19b42d1c8565777c@mail.gmail.com>
	<20090511165317.3da5326f@lxorguk.ukuu.org.uk>
	<ac3eb2510905110928g12545518y143f7f73b3ae494a@mail.gmail.com>
	<20090511094151.6014cafb@infradead.org>
	<ac3eb2510905111032u13051b74g81573a18e3545a81@mail.gmail.com>
	<20090511185513.45ea4754@lxorguk.ukuu.org.uk>
	<ac3eb2510905111104g5ce4e8e6xf8b4de41454c3d2f@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Right, but the information you need for all other use cases is already
> there today in /sys. This is about something new, so there is not a
> competition about features, just an option to solve a problem in a
> different way, which we prefer over the current one.

"we". You don't speak for me or a lot of people on this one.

Running a second udevd seems to be overkill. You know which nodes you've
created so far so you know which series of rules to reapply.

> just an option to solve a problem in a different way

There are thousands of kernel contributors. If they all submit everything
that solves their problem, their way we'd drown in the resulting mess.
devfs was Richard Gooch's way perhaps we should add that back as well,
and a variant that uses a data file for me, and a different one for Arjan.

We could let everyone invent new arbitary APIs for all their device
drivers so you need a different app for each pointing device or
each light level sensor ....

That way lies *madness*.

