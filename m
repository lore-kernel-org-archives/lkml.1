Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbZBMSGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbZBMSGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 13:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbZBMSFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 13:05:49 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:11723 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbZBMSFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 13:05:48 -0500
Date: Fri, 13 Feb 2009 13:05:28 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: Nico Schottelius <nico-linux-20090213@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org
Subject: Re: X200: Brightness broken since 2.6.29-rc4-58-g4c098bc
In-reply-to: <20090213094200.GC17774@elte.hu>
Message-id: <alpine.LFD.2.00.0902131302240.3671@localhost.localdomain>
References: <20090213093354.GA10175@denkbrett.schottelius.org>
 <20090213094200.GC17774@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > When using
> >   - vmlinuz-2.6.29-rc4-ikn-00058-g4c098bc or
> >   - vmlinuz-2.6.29-rc4-ikn-00211-g37bed90
> > 
> > the brightness of the LCD is almost off (lowest level),
> > although kernel reports otherwise:
> > 
> > [10:31] ikn:~% cat /proc/acpi/video/VID/LCD0/brightness 
> > levels:  20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 100
> > current: 100
> > 
> > Changing the brightness via echo 20 > /proc/acpi/video/VID/LCD0/brightness
> > only changes the value displayed, the display always keeps the same
> > brightness.
> > 
> > The last time I saw it working was vmlinuz-2.6.29-rc4-ikn-00001-gd5b5623.

Nico,
there are not a lot of changes between rc4 and the breakage,
(and none of them jump out at me) can you git-bisect?

thanks,
Len Brown, Intel Open Source Technology Center


