Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbZAHK6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbZAHK6J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbZAHK54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:57:56 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40869 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750956AbZAHK5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:57:55 -0500
Date: Thu, 8 Jan 2009 10:56:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "M. Warner Losh" <imp@bsdimp.com>, mayer@ntp.isc.org,
       linasvepstas@gmail.com, david@lang.hm, hancockr@shaw.ca,
       kyle@moffetthome.net, slashdot@jameshallam.info, goodgerster@gmail.com,
       davidn@davidnewall.com, linux-kernel@vger.kernel.org,
       ntpwg@lists.ntp.isc.org, pretzalz@techhouse.org,
       burdell@iruntheinter.net, nick@nick-andrew.net, jeff@kosowsky.org
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on
 new years 2008-2009
Message-ID: <20090108105656.6457f6cc@lxorguk.ukuu.org.uk>
In-Reply-To: <20090108104854.2dbc41b1@lxorguk.ukuu.org.uk>
References: <20090107.103947.1324582654.imp@bsdimp.com>
	<20090107193127.0bec8ad8@lxorguk.ukuu.org.uk>
	<496579C2.5050800@ntp.isc.org>
	<20090107.214220.-233694826.imp@bsdimp.com>
	<20090108104854.2dbc41b1@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2009 10:48:54 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > On FreeBSD, Solaris and Digital Unix, I'll point out, that jumping
> > backwards is used, and has been used since at least 1994.  So saying
> > it isn't used in the world today is flat out wrong.

[Ignore previous email, must remember not to post before waking up  ;)]

You are correct - and providing gettimeofday() is being used on Linux
rather than time() which simply appears to stall due to resolution the
same is true.

Some users do run with the "right" timezone data in non posix mode
because they want their seconds 'sane' but that isn't the default.

Alan


