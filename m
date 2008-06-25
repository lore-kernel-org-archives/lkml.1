Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbYFYXMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbYFYXMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbYFYXMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:12:21 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:52682 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbYFYXMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:12:20 -0400
Date: Wed, 25 Jun 2008 19:12:12 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2.6.26-rc] ACPI Thermal Zone driver breaks lm-sensors 2
 userspace
In-reply-to: <48613130.7090004@keyaccess.nl>
X-X-Sender: lenb@localhost.localdomain
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Zhang Rui <rui.zhang@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robert Hancock <hancockr@shaw.ca>, Hans de Goede <j.w.r.degoede@hhs.nl>,
       Jean Delvare <khali@linux-fr.org>, linux-acpi@vger.kernel.org,
       lm-sensors@lm-sensors.org, Linux Kernel <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.1.10.0806251845160.3279@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <fa.4PGqX9CuLbgiTimfCcon+PlAMxk@ifi.uio.no>
 <fa.PWu620xEt5OlYdOezvRtQriuNjM@ifi.uio.no> <48605935.5070407@shaw.ca>
 <alpine.LFD.1.10.0806232004480.2926@woody.linux-foundation.org>
 <1214279258.3001.76.camel@rzhang-dt.sh.intel.com>
 <20080624121455.GM7306@mars.solarsys.private> <48613130.7090004@keyaccess.nl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Len suggested the default be hwmon support enabled

I think you were right and I was wrong on that part,
lets default =n.

What is new here is thermal I/F to hwmon.
Distros what want it will know they need libsensors 2.10.7
or libsensors 3.x before they turn it on.

libsensors <= 2.10.6 users who upgrade their kernel to 2.6.26
without distro support will get no bad surprises.

The down-side is simply that we are being less aggressive about
exposing these temperature readings via hwmon.
I'm not going to lose any sleep over that.

-Len








