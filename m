Return-Path: <linux-kernel-owner+w=401wt.eu-S1751826AbXAVTYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbXAVTYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbXAVTYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:24:42 -0500
Received: from scrye.com ([216.17.180.1]:54476 "EHLO mail.scrye.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbXAVTYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:24:41 -0500
Subject: Re: PROBLEM: KB->KiB, MB -> MiB, ... (IEC 60027-2)
From: Tony Foiani <tkil@scrye.com>
Reply-To: Tony Foiani <tkil@scrye.com>
X-Attribution: Tony
To: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Eduard Bloch <edi@gmx.de>, Bodo Eggert <7eggert@gmx.de>,
       David Schwartz <davids@webmaster.com>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       linux-kernel@vger.kernel.org
References: <7FsPf-51s-9@gated-at.bofh.it> <7FxlV-3sb-1@gated-at.bofh.it> <7FyUF-5XD-21@gated-at.bofh.it> <E1H8a7s-0000at-Jx@be1.lrz> <20070121111000.GA6679@rotes76.wohnheim.uni-kl.de> <20070122155354.GB25916@csclub.uwaterloo.ca> <Pine.LNX.4.61.0701221756000.317@yvahk01.tjqt.qr> <20070122183619.2db6538e@localhost.localdomain>
Date: Mon, 22 Jan 2007 12:24:40 -0700
In-Reply-To: <20070122183619.2db6538e@localhost.localdomain> (alan@lxorguk.ukuu.org.uk's message of "Mon, 22 Jan 2007 18:36:19 +0000")
Message-ID: <gsle2n9tz.fsf@brand.scrye.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jan" == Jan Engelhardt <jengelh@linux01.gwdg.de> writes:

Jan> For "F"s sake, when you gotta use abbreviations, then just use
Jan> k=1000 and K=1024 already, b for bits and B for bytes. Problem
Jan> gone.

   The one-letter abbreviations are identical to SI prefixes, except
   for "K", which is used interchangeably with "k" (in SI, "K" stands
   for the kelvin, and only "k" stands for 1,000).

   [...]

   BIPM (which maintains SI) expressly prohibits the binary prefix
   usage, and recommends the use of the IEC prefixes as an alternative
   (computing units are not included in SI).

   Some have suggested that "k" be used for 1,000, and "K" for 1,024,
   but this cannot be extended to the higher order prefixes and has
   never been widely recognised.
   -- http://en.wikipedia.org/wiki/Binary_prefix

So if you continue insisting that "MB" is really 2^20 bytes, you're
flouting the SI in at least two ways.  I'd expect that from an USAian,
not a German.  ;-> (To be clear, I *am* a USAian, and I really
desperately wish this country were metric...)

Some other gems from that article that haven't been covered in this
thread:

 * CD-Rs are generally specified in MiB, but DVD-Rs in GB
 * CPU clocks are given in decimal

(See http://en.wikipedia.org/wiki/Binary_prefix#Usage_notes )

It also points out that there are some ongoing lawsuits on exactly
this topic, completely analogous to the CRT diagonal cases.

>>>>> "Alan" == Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

Alan> K is Kelvin, k is kilo-

One nice thing about IEC 60027-2 is that it seems to have fixed the
capitalization inconsistency; kibi- really is "Ki".

(I never cared for the lower-case "k" for "kilo-"; there are other
clashes of symbols in the SI system proper; think "milli-" and
"meter".)

The standard also specifically states that "B", when used with the
binary prefixes, is "byte" not "Bel".  Which is nice.

t.
