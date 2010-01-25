Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274Ab0AYJ4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab0AYJ4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 04:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177Ab0AYJ4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 04:56:08 -0500
Received: from lucidpixels.com ([75.144.35.66]:59907 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175Ab0AYJ4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 04:56:04 -0500
Date: Mon, 25 Jan 2010 04:56:02 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Valdis.Kletnieks@vt.edu
cc: linux-kernel@vger.kernel.org
Subject: Re: High pitch noise when ACPI processor module is loaded.
In-Reply-To: <alpine.DEB.2.00.1001250424540.4502@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.1001250455360.4614@p34.internal.lan>
References: <alpine.DEB.2.00.1001231046080.1064@p34.internal.lan> <9883.1264397678@localhost> <alpine.DEB.2.00.1001250424540.4502@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010, Justin Piszcz wrote:

> Hi,
>
> I think something else may be wrong?
>
> I switched my kernel config to 100 HZ and the problem persists.
>
> So the question remains, is it possible to utilize turbo boost (in Linux)
> without the high pitch noise from the ACPI processor module?
>
> Again, when the module is not loaded, no matter what HZ, there is no high 
> pitch noise.
>
> Justin.
>
>

Without ACPI processor module loaded, turbo boost never takes effect:

(turbostat)

  CPU   GHz    TSC    %c0    %c1    %c3    %c6   %pc3   %pc6   %pc7
    0   2.93   2.93   1.41  98.59   0.00   0.00   0.00   0.00   0.00
    1   2.93   2.93 100.00   0.00   0.00   0.00   0.00   0.00   0.00
    2   2.93   2.93   1.51  98.49   0.00   0.00   0.00   0.00   0.00
    3   2.93   2.93   0.97  99.03   0.00   0.00   0.00   0.00   0.00
    4   2.93   2.93   0.90  99.10   0.00   0.00   0.00   0.00   0.00
    5   2.93   2.93   0.34  99.66   0.00   0.00   0.00   0.00   0.00
    6   2.93   2.93   0.40  99.60   0.00   0.00   0.00   0.00   0.00
    7   2.93   2.93   3.07  96.93   0.00   0.00   0.00   0.00   0.00

With the module loaded, it works but there is a high pitch noise, again,
only under Linux, when the same benchmark (bzip2 a file) is run under windows
there is no high pitch noise:

  CPU   GHz    TSC    %c0    %c1    %c3    %c6   %pc3   %pc6   %pc7
    0   3.30   2.93   0.44   0.82  25.29  73.44   0.00   0.00   0.00
    1   3.33   2.93   0.24   1.02  25.29  73.44   0.00   0.00   0.00
    2   3.43   2.93   1.84   5.41  48.65  44.10   0.00   0.00   0.00
    3   3.41   2.93   0.49   6.76  48.65  44.10   0.00   0.00   0.00
    4   3.58   2.93  99.44   0.56   0.00   0.00   0.00   0.00   0.00
    5   3.43   2.93   0.03  99.97   0.00   0.00   0.00   0.00   0.00
    6   3.09   2.93   0.14   0.23  89.74   9.89   0.00   0.00   0.00
    7   2.13   2.93   0.01   0.36  89.74   9.89   0.00   0.00   0.00


Justin.


