Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbZC0Sg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbZC0Sg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 14:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754295AbZC0SgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 14:36:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:16753 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbZC0SgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 14:36:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-type:content-transfer-encoding:x-mailer
         :thread-index:content-language;
        b=fQVLcnVq90nKVEzhMF0BIkXLU4wEp+6KDeVviuDxeGtiTHQ0KdmZrZQSCYGI+403rl
         cwhkSB2ql51ySTr2qVhrT7e5GzagEnNgweeNPhWZyyHg/4FdsCSm3kjkkMIH0kc5BVg3
         JLnUJbWxcZ4e66w92wnvbuFO2k5j9M1yI8y44=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>,
       "'Matthew Garrett'" <mjg59@srcf.ucam.org>
Cc: "'Theodore Tso'" <tytso@mit.edu>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'David Rees'" <drees76@gmail.com>, "'Jesper Krogh'" <jesper@krogh.cc>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
References: <20090327051338.GP6239@mit.edu>	<20090327055750.GA18065@srcf.ucam.org>	<20090327062114.GA18290@srcf.ucam.org>	<20090327112438.GQ6239@mit.edu>	<20090327145156.GB24819@srcf.ucam.org>	<20090327150811.09b313f5@lxorguk.ukuu.org.uk>	<20090327152221.GA25234@srcf.ucam.org>	<20090327161553.31436545@lxorguk.ukuu.org.uk>	<20090327162841.GA26860@srcf.ucam.org>	<20090327165150.7e69d9e1@lxorguk.ukuu.org.uk>	<20090327170208.GA27646@srcf.ucam.org> <20090327171955.78662c1e@lxorguk.ukuu.org.uk>
In-Reply-To: <20090327171955.78662c1e@lxorguk.ukuu.org.uk>
Subject: RE: Linux 2.6.29
Date: Fri, 27 Mar 2009 11:36:07 -0700
Message-ID: <019001c9af0a$e65a4860$b30ed920$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcmvAHS6u2vu5Eo6T3iTM/N70MoDXwACDv/w
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why are we even arguing about standards?

POSIX, as all other standards, is a common _denominator_ and absolutely the
_minimal_ requirement for a compliant operating system. It does not tell you
how to design the best systems in the real world. For God's sake, can't we
aim for something higher than a piece of literature written some 20 years
ago? And stop making excuses please?

The fact is, most software is crap, and most software developers are lazy
and stupid. Same as most customers are stupid too. A technically correct
operating system isn't necessarily the most successful and accepted
operating system. Have a sense of pragmatism if you are developing something
that is not just a fancy research project.

And it's especially true for ext4. I bet nobody would care about what it did
if it called itself bloody-fast-next-gen-fs, and of course probably nobody
would use it either. But since it's putting the "ext" and "next default
Linux filesystem in all distros" hat on, it'd better take both the glory and
the crap with it. So, no matter whether ext3 made some mistakes, you can't
just throw it all away while keeping its name to give people the false sense
of comfort.

I am really glad that Theodore changed ext4 to handle the common practice of
truncate/rename sequences. It's absolutely necessary. It's not a "favor for
stupid user space", but a mandatory requirement if you even remotely want it
to be a general-purpose file system. In the end, it doesn't matter how
standard compliant you are - people will only choose the filesystem that is
the most reliable, fastest, and works with the most number of applications.

Hua


