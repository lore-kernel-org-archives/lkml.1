Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbZKJV0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbZKJV0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbZKJV0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:26:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57540 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbZKJV0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:26:44 -0500
Message-ID: <4AF9D8E2.7050205@zytor.com>
Date: Tue, 10 Nov 2009 13:19:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Pavel Machek <pavel@ucw.cz>, Avi Kivity <avi@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matteo Croce <technoboy85@gmail.com>,
       Sven-Haegar Koch <haegar@sdinet.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
References: <4AF9020C.90108@zytor.com> <4AF9435F.2070103@redhat.com> <20091110105642.215804e0@lxorguk.ukuu.org.uk> <4AF99E04.8080704@zytor.com> <20091110172454.3c4481f2@lxorguk.ukuu.org.uk> <4AF9B5AB.5010800@zytor.com> <4AF9C3EF.6000705@redhat.com> <4AF9C6AB.8080006@zytor.com> <20091110201602.GA26633@1wt.eu> <20091110205445.GB1407@ucw.cz> <20091110211259.GD26633@1wt.eu>
In-Reply-To: <20091110211259.GD26633@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 01:12 PM, Willy Tarreau wrote:
> yes, just like with emulated FPU or trapped unaligned accesses. It's
> just like flying fishes. They exist but they aren't the most common
> ones. If people encounter these cases on a specific program, then
> they just have to recompile it if it is a problem. At least they
> don't rebuild the whole distro. And once again, I've been using
> cmpxchg/bswap emulation for years on my i386 without feeling any
> need for a rebuild, and CMOV emulation for years now on my mini-itx 
> C3 without any problem either. These are real experiences, not just
> fears of imaginary problems. Yes I can design a program to run 400
> times slower on these machines if I want. I just don't feel the need
> to do so and apparently existing programs' authors didn't either.

Willy, perhaps you can come up with a list of features you think should
be emulated, together with an explanation of why you opted for that list
of features and *did not* opt for others.

Note: emulated FPU is a special subcase.  The FPU operations are
heavyweight enough that the overhead of trapping versus library calls is
relatively insignificant.

	-hpa

