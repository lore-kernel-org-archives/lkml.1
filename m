Return-Path: <linux-kernel-owner+w=401wt.eu-S932952AbXAaKer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952AbXAaKer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 05:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932955AbXAaKer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 05:34:47 -0500
Received: from s4.cableone.net ([24.116.0.230]:49221 "EHLO S4.cableone.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952AbXAaKeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 05:34:46 -0500
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jan 2007 05:34:46 EST
Message-ID: <36577.129.240.220.12.1170238420.squirrel@peltkore.net>
In-Reply-To: <Pine.LNX.4.61.0701301512200.1147@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6>
    <45BF3954.8050106@yahoo.com.au>
    <Pine.LNX.4.64.0701300753170.23302@CPE00045a9c397f-CM001225dbafb6>
    <Pine.LNX.4.61.0701301512200.1147@yvahk01.tjqt.qr>
Date: Wed, 31 Jan 2007 11:13:40 +0100 (CET)
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h.
From: "Vegard Nossum" <vegard@peltkore.net>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Paul Mackerras" <paulus@samba.org>,
       dhowells@redhat.com, galak@kernel.crashing.org
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-IP-stats: Incoming Last 0, First 78, in=788, out=0, spam=0
X-External-IP: 69.92.239.151
X-Abuse-Info: Send abuse complaints to abuse@cableone.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, January 30, 2007 3:12 pm, Jan Engelhardt wrote:
>
>>> Why the qualifier? Zero *is* not a power of 2, is it?
>
> No, it is not:
>
> 	In[1]:= Solve[2^n == 0, n]
>
> 	Out[1]= {}
>
> So says Mathematica5.

As a side note, I would just like to point out that Mathematica does not
deal with modular arithmetic by default (which programmers very much do).
In fact, in modular arithmetic, zero IS a power of two.

2^n = 0 (mod 2^n)

To see if it holds for bytes, substitute n = 8, and you get 2^8 = 0 (mod
256). In other words: Zero is the eighth power of two modulo 256.

Modular arithmetic is, however, very often a source of errors in
programming (unchecked-for overflows and underflows), and it is
questionable whether the programmer would really want 0 reported as a
power of two.


Vegard

