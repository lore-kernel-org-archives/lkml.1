Return-Path: <linux-kernel-owner+w=401wt.eu-S1752899Ab0AYMl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab0AYMl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 07:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294Ab0AYMl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 07:41:28 -0500
Received: from lucidpixels.com ([75.144.35.66]:43139 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab0AYMl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 07:41:27 -0500
Date: Mon, 25 Jan 2010 07:41:25 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: High pitch noise when ACPI processor module is loaded.
In-Reply-To: <20100125123311.GC3182@khazad-dum.debian.net>
Message-ID: <alpine.DEB.2.00.1001250738220.9341@p34.internal.lan>
References: <alpine.DEB.2.00.1001231046080.1064@p34.internal.lan> <9883.1264397678@localhost> <alpine.DEB.2.00.1001250424540.4502@p34.internal.lan> <20100125123311.GC3182@khazad-dum.debian.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 Jan 2010, Henrique de Moraes Holschuh wrote:

> On Mon, 25 Jan 2010, Justin Piszcz wrote:
>> So the question remains, is it possible to utilize turbo boost (in Linux)
>> without the high pitch noise from the ACPI processor module?
>
> Well, I am tempted to say you should consider getting a higher quality
> motherboard (or, if it is just yours that sing, get it replaced on warranty
> as that would mean you got one with bad components).
>
> That said, if Windows can get that motherboard to shut up, so should Linux.
> You just need to find the right knob to push that will make the power draw
> behaviour more like whatever Windows is doing.
>
> The first good bet is to limit core C-state depth, e.g, to C3 (instead of
> C5/C6), and if thet doesn't work, to C2.  After that, you can try limiting
> package C-states if your BIOS will let you (I don't know if we can do that
> distinction in Linux right now... do we?), play with cpufreq limiting the
> core frequency changes, etc.
>
> And of course, try all scheduler frequencies, with and without NO_HZ.
>
> What motherboard is this?
Intel's DP55KG Extreme motherboard, yes I will try changing the c-state 
later and hopefully that will fix the problem, thanks.  Again, the board 
never makes any noise in the BIOS or Windows or Linux, only when you load 
the cpufreq-processor module.

Justin.
