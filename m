Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbZBDFwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbZBDFwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 00:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbZBDFw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 00:52:27 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:42774 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZBDFw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 00:52:26 -0500
Date: Wed, 04 Feb 2009 00:52:06 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: Thomas Renninger <trenn@suse.de>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
       khali@linux-fr.org
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
In-reply-to: <68676e00901290716g1aabd6c0p1e5202fbdbc659a4@mail.gmail.com>
Message-id: <alpine.LFD.2.00.0902040042570.9833@localhost.localdomain>
References: <20090125210520.GA12963@dreamland.darkstar.lan>
 <200901291130.35434.trenn@suse.de>
 <68676e00901290716g1aabd6c0p1e5202fbdbc659a4@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009, Luca Tettamanti wrote:

> Aside from ASUS the problem is generic since there are two drivers
> poking at the same hardware; for example there are reports of native
> drivers interfering with normal TZ polling (see [1]).

FYI,

While it is slightly off-topic of the (I agree, real)
technical issue here, note that polling is not "normal" on ACPI systems.
[1] was on  SuSE Linux 10.0, which on their own decided to
over-ride the kernel and enable thermal zone polling by default.

This turned out to be a bad idea because it exposed BIOS bugs
in ACPI thermal zones that were never exposed on other operating
systems - evidently because the other operating systems never 
poll thermal zones, they are entirely event driven.

cheers,
Len Brown, Intel Open Source Technology Center

> Luca
> [1] http://www.lm-sensors.org/ticket/2072 and:
> http://thread.gmane.org/gmane.linux.drivers.sensors/12359

