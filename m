Return-Path: <linux-kernel-owner+w=401wt.eu-S1759986AbZACODj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986AbZACODj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 09:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758867AbZACODa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 09:03:30 -0500
Received: from khc.piap.pl ([195.187.100.11]:56769 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758403AbZACOD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 09:03:29 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, rdreier@cisco.com,
       ian.campbell@citrix.com, jeremy.fitzhardinge@citrix.com, deller@gmx.de,
       rusty@rustcorp.com.au, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, kyle@mcmartin.ca, randolph@tausq.org,
       dave@hiauly1.hia.nrc.ca
Subject: Re: [PATCH] kbuild: Disallow GCC 4.1.0 / 4.1.1
References: <alpine.LFD.2.00.0812310942110.5086@localhost.localdomain>
	<20081231105425.9ccac21d.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0812311318420.5086@localhost.localdomain>
	<20081231.141408.60544902.davem@davemloft.net>
	<20090102115547.GB3027@elte.hu>
	<alpine.LFD.2.00.0901020844070.5086@localhost.localdomain>
	<alpine.LFD.2.00.0901020933370.5086@localhost.localdomain>
	<20090102175737.GA5818@uranus.ravnborg.org>
	<alpine.LFD.2.00.0901021000020.5086@localhost.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 03 Jan 2009 15:03:21 +0100
In-Reply-To: <alpine.LFD.2.00.0901021000020.5086@localhost.localdomain> (Linus Torvalds's message of "Fri\, 2 Jan 2009 10\:04\:27 -0800 \(PST\)")
Message-ID: <m38wpssd06.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> I realize that cross-tools tend to lag a bit - the pressure to maintain 
> them tends to be much lower - but I was sure we had somebody who did a 
> reasonable cross-compiler toolchain. Is gcc-4.1 really the most modern 
> thing that is easily available?

Not sure about crosstool and other platforms but I'm using gcc 4.3.2+
for ARM (on x86_64) and building it is straightforward. Just unpack
binutils, gcc (and optionally glibc); configure; make; make install.
Prerequisites: kernel headers and minimal glibc installed.
(Some recent glibc versions require a patch or two).
-- 
Krzysztof Halasa
