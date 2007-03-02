Return-Path: <linux-kernel-owner+w=401wt.eu-S965634AbXCBVHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965634AbXCBVHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965632AbXCBVHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:07:18 -0500
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:3946 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965627AbXCBVHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:07:16 -0500
Date: Fri, 2 Mar 2007 22:04:54 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pavel Machek <pavel@ucw.cz>, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-Id: <20070302220454.a0c66d04.khali@linux-fr.org>
In-Reply-To: <20070302141840.GA3441@srcf.ucam.org>
References: <45D5EA88.7090300@redhat.com>
	<45D6DDCE.5050803@assembler.cz>
	<45D7461A.2040808@redhat.com>
	<20070218183805.5a4fd813.khali@linux-fr.org>
	<20070228213803.GA4877@ucw.cz>
	<20070301152655.f232db64.khali@linux-fr.org>
	<20070302114023.GD2163@elf.ucw.cz>
	<20070302114747.GB1212@srcf.ucam.org>
	<20070302151055.d2665d66.khali@linux-fr.org>
	<20070302141840.GA3441@srcf.ucam.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007 14:18:40 +0000, Matthew Garrett wrote:
> On Fri, Mar 02, 2007 at 03:10:55PM +0100, Jean Delvare wrote:
> 
> > I'm not familiar with APCI at all so I didn't know, but what you write
> > here brings some hope. Would it be possible to parse all the DSDT code
> > at boot time and deduce all the ports which ACPI would need to request
> > to be safe? Or do we have to wait for the accesses to actually happen?
> 
> In theory I /think/ so, but it would probably end up being an 
> overestimate of the coverage actually needed. Trapping at runtime is 
> arguably more elegant?

It might be more elegant but it won't work. We don't want to prevent
ACPI from accessing these I/O ports. If we need to choose only one
"driver" accessing the I/O port, it must be acpi, at leat for now,
despite the fact that acpi provides very weak hardware monitoring
capabilities compared to the specific drivers.

Why would we end up with an overestimation if we check the I/O ports at
boot time? Do you have concrete cases in mind?

Thanks,
-- 
Jean Delvare
