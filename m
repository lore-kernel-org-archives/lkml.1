Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252Ab0AYUqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab0AYUqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 15:46:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130Ab0AYUqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 15:46:10 -0500
Received: from lucidpixels.com ([75.144.35.66]:36793 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab0AYUqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 15:46:09 -0500
Date: Mon, 25 Jan 2010 15:46:06 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Ian Campbell <ijc@hellion.org.uk>
cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: High pitch noise when ACPI processor module is loaded.
In-Reply-To: <1264414241.16526.84480.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.00.1001251543450.4578@p34.internal.lan>
References: <alpine.DEB.2.00.1001231046080.1064@p34.internal.lan>  <9883.1264397678@localhost>  <alpine.DEB.2.00.1001250424540.4502@p34.internal.lan> <1264414241.16526.84480.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 25 Jan 2010, Ian Campbell wrote:

> On Mon, 2010-01-25 at 04:26 -0500, Justin Piszcz wrote:
>> So the question remains, is it possible to utilize turbo boost (in Linux)
>> without the high pitch noise from the ACPI processor module?
>
> I have to use the max_cstate=2 option to processor.ko in order to not
> have a similar high pitch noise. I suppose you might get away higher
> values of max_cstate depending on your hardware. Battery life doesn't
> seem to be too adversely impacted.

Hello,

I tried this, but then the max speed bin is only 3.2GHz instead of 3.6GHz,
it does solve the problem but limits the CPU quite a bit, see below:

  CPU   GHz    TSC    %c0    %c1    %c3    %c6   %pc3   %pc6   %pc7
    0   3.20   2.93   0.33  99.67   0.00   0.00   0.00   0.00   0.00
    1   3.20   2.93   0.09  99.91   0.00   0.00   0.00   0.00   0.00
    2   3.20   2.93 100.00   0.00   0.00   0.00   0.00   0.00   0.00
    3   3.20   2.93   0.95  99.05   0.00   0.00   0.00   0.00   0.00
    4   3.20   2.93   0.08  99.92   0.00   0.00   0.00   0.00   0.00
    5   3.20   2.93   0.02  99.98   0.00   0.00   0.00   0.00   0.00
    6   3.20   2.93   0.06  99.94   0.00   0.00   0.00   0.00   0.00
    7   3.20   2.93   0.01  99.99   0.00   0.00   0.00   0.00   0.00

--

It would be nice if it were possible to find out what is causing it exactly
in the acpi cpufreq module, as this problem does not occur in Windows 7 and
I can achieve 3.6GHz in Windows 7 w/out any high pitch noise.

Justin.

