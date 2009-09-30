Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbZI3V76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbZI3V76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 17:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753827AbZI3V75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 17:59:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50347 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106AbZI3V75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 17:59:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kelly Bowa <kbpm@tuxedu.org>
Subject: Re: __pm_runtime_idle() returns -11!
Date: Thu, 1 Oct 2009 00:01:23 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>
References: <20090930074650.GA2300@box.home>
In-Reply-To: <20090930074650.GA2300@box.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910010001.23869.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 September 2009, Kelly Bowa wrote:
> Hi Rafael,
> 
> I get the following error messages in dmesg:
> 
> [    0.488758] ACPI: Enumerating devices from [\]
> [    0.489673] PM: Adding info for acpi:LNXSYSTM:00
> [    0.489856] acpi LNXSYSTM:00: __pm_runtime_idle()!
> [    0.489862] acpi LNXSYSTM:00: __pm_runtime_idle() returns -11!
> [    0.490952] PM: Adding info for acpi:LNXCPU:00
> [    0.491154] acpi LNXCPU:00: __pm_runtime_idle()!
> [    0.491161] acpi LNXCPU:00: __pm_runtime_idle() returns -11!
> ....
> 
> full dmesg: www.tuxedu.org/kbpm/dmesg2.txt
> 
> __pm_runtime_idle() returns -11 which could be that it is waiting for other 
> suspend running in parallel or that pm_runtime_cancel() fails to suspend the 
> given device ?.. this causes a noticeable delay in boot time. I get this on 
> 2.6.31-mm1 and ill soon test against 2.6.32-rc1..

This is a result of a debug message which is not supposed to be enabled on
production systems.  What debug options are enabled in your kernel config?

Rafael
