Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbZAHEoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbZAHEoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 23:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZAHEoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 23:44:23 -0500
Received: from bsdimp.com ([199.45.160.85]:57916 "EHLO harmony.bsdimp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbZAHEoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 23:44:23 -0500
Date: Wed, 07 Jan 2009 21:42:20 -0700 (MST)
Message-Id: <20090107.214220.-233694826.imp@bsdimp.com>
To: mayer@ntp.isc.org
Cc: alan@lxorguk.ukuu.org.uk, linasvepstas@gmail.com, david@lang.hm,
       hancockr@shaw.ca, kyle@moffetthome.net, slashdot@jameshallam.info,
       goodgerster@gmail.com, davidn@davidnewall.com,
       linux-kernel@vger.kernel.org, ntpwg@lists.ntp.isc.org,
       pretzalz@techhouse.org, burdell@iruntheinter.net, nick@nick-andrew.net,
       jeff@kosowsky.org
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on
 new years 2008-2009
From: "M. Warner Losh" <imp@bsdimp.com>
In-Reply-To: <496579C2.5050800@ntp.isc.org>
References: <20090107.103947.1324582654.imp@bsdimp.com>
	<20090107193127.0bec8ad8@lxorguk.ukuu.org.uk>
	<496579C2.5050800@ntp.isc.org>
X-Mailer: Mew version 5.2 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message: <496579C2.5050800@ntp.isc.org>
            Danny Mayer <mayer@ntp.isc.org> writes:
: Alan Cox wrote:
: >> time, causing time to jump backwards by 1s (or violate POSIX time_t's
: >> invariant that midnight time_t is % 86400 == 0).  This jump backwards
: >> is a pita in the kernel, and violates the assumption that many
: >> programs have that time doesn't flow backwards.
: > 
: > They can slew the clock slowly as well. There is a wonderful quote from
: > one of the summaries of the POSIX committee discussions on time that says
: > quite simply "the posix clock is not guaranteed to be accurate"
: > 
: > As it currently stands the kernel contains sufficient support that at the
: > point you know a leap second is coming you can adjust the second length
: > marginally over the entire period.
: > 
: > The current behaviour is an implementation decision. Jumping on a second
: > shouldn't be an issue to most people, jumping back is asking for badness
: > but isn't in fact used in the world today. Slewing the entire day so that
: > each second is 1/86400 of a second longer or shorter wouldn't be noticed
: > by anyone.
: 
: NTP handles most of this, but it needs the cooperation of the O/S kernel
: and most of the Unix kernels are able to provide the required API's.
: FreeBSD doesn't have any of these problems but Linux historically has.
: Most of that code was designed by Dave Mills but since each kernel is
: different we should not expect them all to behave the same way and
: generally requires an understanding of what NTP expects and that's not
: always clear to kernel developers who are not expected to know NTP.

On FreeBSD, Solaris and Digital Unix, I'll point out, that jumping
backwards is used, and has been used since at least 1994.  So saying
it isn't used in the world today is flat out wrong.

Warner
