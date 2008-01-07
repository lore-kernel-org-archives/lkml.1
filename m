Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbYAGKmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbYAGKmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 05:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbYAGKmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 05:42:47 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:20292 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754314AbYAGKmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 05:42:46 -0500
Message-ID: <47820224.2020902@msgid.tls.msk.ru>
Date: Mon, 07 Jan 2008 13:42:44 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: acpi/apm events as inputs: how to handle?
References: <477B5FD8.5070503@msgid.tls.msk.ru> <200801052105.03068.dtor@insightbb.com>
In-Reply-To: <200801052105.03068.dtor@insightbb.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> Hi Michael,

Hello!

[]
> There are keyboards (USB, PS2) with Sleep and Suspend buttons
> that are not related to ACPI nor APM. We had 2 options - add
> an input handler that would translate input events into ACPI
> events and feed /proc/acpi/event[*] or go other way around and
> use input layer for delivering suspend and sleep requests for
> all types of keyboards/buttons, including ACPI buttons. The
> secons option is better because userspace solution using input
> layer will not be tied to a particular technology (ACPI) and
> can be used on other platforms as well.

Aha, this makes sense.
And it brings a few questions, too.

As far as I can see, there's little information about how to
actually use the input interface.  Let's suppose I'm about to
write an application (a daemon) that should replace acpid --
it's handling of the said buttons (power and sleep).  How to
find the right devices?  Should it use /dev/input/event* or
something else?  How about handling hot-plugged devices like
new (and removed) keyboards? (And yes, my keyboard has a sleep
button.)

And by the way, what INPUT can one expect from a PC speaker?
input: PC Speaker as /devices/platform/pcspkr/input/input0

Thanks!

/mjt
