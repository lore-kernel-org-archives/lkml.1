Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbYLSWTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbYLSWTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755408AbYLSWT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:19:27 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:48812 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004AbYLSWT0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:19:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=t10DnroD1q1VQ/vTDb9yHMbJcFg5/OiHax0umbQQGqv6sYFcAnan46sNGRLggYgcps
         RKYm5PM2mQJlPJTIjY3BJfF+Q9l4XHZ49+5AsiUisFIJYN7S86+OgO8oVizkuy4QLgQJ
         7E+o2vew7u1UoBeIROF9LR76+dtJdmCRO9CKQ=
Message-ID: <4807377b0812191419k42b7749chff70f0e217a24cfe@mail.gmail.com>
Date: Fri, 19 Dec 2008 14:19:25 -0800
From: "Jesse Brandeburg" <jesse.brandeburg@gmail.com>
To: "Mihai Moldovan" <ionic@ionic.de>
Subject: Re: Multiple minor glitches with 2.6.27.* and linux-NEXT
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <494BABB0.8050309@ionic.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <494BABB0.8050309@ionic.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 6:12 AM, Mihai Moldovan <ionic@ionic.de> wrote:
> First of all, will the changes to e1000e be integrated in Linux 2.6.28
> as soon as it is released? 2.6.27 does not detect my onboard NIC, whilst
> Linux-NEXT does. Some basic information about this:

2.6.28 should have support for 8086/10de.

<big snip>

> Might anyone here be so kind to explain me whether disabling specific
> Cores of an Intel(R)™ Core2Quad CPU completely ...
>
>  - is possible? I am not quite sure whether this would work at all.
>  - would indeed safe power/lower the power consumption? Logically
> disabling cores does safe hardly any power. :)

I'm not the best person to answer, but if you enable TICKLESS kernel
and ACPI power states (and run one of the powersave governors,
basically treating your desktop like a laptop) then your CPUs will use
very little power.

You should be able to get an idea of the power being used by your
system by seeing how much time it spends in C1/C2/C3, using the
powertop application from http://www.lesswatts.org/projects/powertop/

it will also give suggestions about how to optimize your system.  Why
disable cores when the system will effectively do it for you?  If
you're really serious about conserving power, get a power meter that
goes between your power plug and the wall and measure the wattage
being consumed by your system.
