Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbZCPEYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbZCPEYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 00:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750908AbZCPEYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 00:24:24 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:53175 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbZCPEYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 00:24:23 -0400
Date: Mon, 16 Mar 2009 00:24:18 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Pavel Machek <pavel@suse.cz>
Cc: Matthew Garrett <mjg@redhat.com>,
       Cristiano Prisciandaro <cristiano.p@solnet.ch>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] cpufreq: eeepc 900 frequency scaling driver
In-reply-to: <20081202201442.GA1504@ucw.cz>
Message-id: <alpine.LFD.2.00.0903160020250.30317@localhost.localdomain>
References: <1227454026.7262.59.camel@localhost> <20081123180409.GB7731@ucw.cz>
 <20081202161520.GA18252@srcf.ucam.org> <20081202201442.GA1504@ucw.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2 Dec 2008, Pavel Machek wrote:

> On Tue 2008-12-02 16:15:21, Matthew Garrett wrote:
> > On Sun, Nov 23, 2008 at 07:04:09PM +0100, Pavel Machek wrote:
> > 
> > > Is this really needed? Could we simply talk to the cpu directly,
> > > without help of ACPI?
> > 
> > No. The ACPI write ends up talking to the embedded controller and some 
> > io ports.
> 
> Oops... I always knew that eee-s are broken by design (reporting
> battery percent as mWh, etc...) but I did not realize how bad it
> is. (ACPI has perfectly standard cpu frequency scaling interface, even
> if it is not used too often these days....)

Huh?

What cpufreq driver is deployed more broadly than acpi-cpufreq?
AFAIK, Linux uses it on nearly every ACPI compliant Intel-based
system that has frequency scaling.

-Len

