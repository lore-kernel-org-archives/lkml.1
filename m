Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbXKZQ0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbXKZQ0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbXKZQ0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:26:11 -0500
Received: from wind.enjellic.com ([209.243.13.15]:36259 "EHLO
	wind.enjellic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbXKZQ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:26:10 -0500
Message-Id: <200711261626.lAQGQ8nk023989@wind.enjellic.com>
From: greg@enjellic.com
Date: Mon, 26 Nov 2007 10:26:08 -0600
In-Reply-To: "Kay Sievers" <kay.sievers@vrfy.org>
       "Re: PCMCIA serial_cs driver binding problems." (Nov 23,  9:40am)
Reply-To: greg@enjellic.com
X-Mailer: Mail User's Shell (7.2.5 10/14/92)
To: "Kay Sievers" <kay.sievers@vrfy.org>, greg@enjellic.com
Subject: Re: PCMCIA serial_cs driver binding problems.
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 23,  9:40am, "Kay Sievers" wrote:
} Subject: Re: PCMCIA serial_cs driver binding problems.

Hi Kay, thanks for the note.

> > I've tried to manually echo the device number (0.0 or 1.0) into the
> > /sys/bus/pcmcia/drivers/serial_cs/bind pseudo-file but nothing
> > happens.  The device number is present as a binding if cardmgr frobs
> > things with the pcmcia_ioctl bind commands.

> Did you enable this?
>
> echo -n 1 > /sys/devices/pci0000:00/0000:00:1e.0/0000:15:00.0/0.0/allow_func_id_match
>
> You can watch "udevmonitor --kernel" while doing this, to get the path and
> see what events the kernel creates.
>
> Distros usually set it automatically by udev: ACTION=="add",
> SUBSYSTEM=="pcmcia", ENV{MODALIAS}=="?*", ATTR{allow_func_id_match}="1"

That fixed the problem instantly, thanks for the tip.

I must have spent a couple of hours Google'ing for hints on this.  Is
there any documentation floating around or a site which documents
functionality for these writable pseudo-files in /sys?

Deducing available or needed functionality would seem to be somewhat
of a black art... :-)

> Kay

Thanks again for the pointer, best wishes for a productive week.

}-- End of excerpt from "Kay Sievers"

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"It would appear that we have reached the limits of what it is
 possible to achieve with computer technology, although one should be
 careful with such statements, as they tend to sound pretty silly in 5
 years."
                                -- John Von Neumann (ca. 1949)
