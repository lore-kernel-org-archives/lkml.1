Return-Path: <linux-kernel-owner+w=401wt.eu-S1760111AbYCCJbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111AbYCCJbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 04:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757595AbYCCJbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 04:31:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:60003 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbYCCJbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 04:31:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sNpC5VsqI6csowyVNEy3JCHD9qNlkhb5j1psnDGNVSWo0hlARRdCLLqTG9NOD5HBGuNcM0sAC2FC0nG0XSS2gLeenJB8mQHLMH/qEBy1oPk5QNqdeC9JCkB0PCG51PoPujH+uuKh+iTcXC3NyOeAkapFidmszt957tFEhJ4RjrQ=
Message-ID: <4ac2955e0803030131t72354cecpbdaf53460ef3d09f@mail.gmail.com>
Date: Mon, 3 Mar 2008 15:01:00 +0530
From: "mahendra varman" <mahendravarman15@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: usb detecting only high speed devices only - not detecting low speed devices
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <200802261817.02830.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4ac2955e0802260543n7d7e5d81nb590d2bc10648269@mail.gmail.com>
	 <20080226160538.086a681d.akpm@linux-foundation.org>
	 <200802261817.02830.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 7:47 AM, David Brownell <david-b@pacbell.net> wrote:
> On Tuesday 26 February 2008, Andrew Morton wrote:
>  > > usb 3-1: new low speed USB device using ohci_hcd and address 2
>  > > ohci_hcd 0000:01:04.1: Unlink after no-IRQ?  Controller is probably
>  > > using the wrong IRQ.
>
>  My diagnosis hasn't changed since last time he asked this question:
>  it's related to IRQ handling, outside the scope of USB.  If USB
>  were getting the OHCI interrupts, it would not issue that message.
>
>  Now as to *why* that happens, I don't know.  We've certainly had folk
>  using Philips/NXP EHCI controllers successfully before.  Maybe this
>  board has a hardware problem, like a bad chip or not having wired
>  up the power lines that OHCI controller uses.

still the low speed devices are giving unlink after no IRQ.. My
hardware engineer says he followed the reference schematics of ISP1562
of philips. He says that ohci side, the power lines are wired up

My Ehci devices can be mounted and the files are read
Today I faced another issue
For some usb ehci devices its giving "device descriptor read/64, error
-71" ( for some usb stick of usb2.0)
but for others i can able to mount without this error.....

Sir, Any clue regarding the above problem iam facing currently ??

Thanks
