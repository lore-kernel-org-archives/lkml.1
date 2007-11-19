Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbXKSPKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbXKSPKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 10:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbXKSPJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 10:09:51 -0500
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:54221 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171AbXKSPJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 10:09:49 -0500
Date: Mon, 19 Nov 2007 15:09:26 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Oliver Neukum <oliver@neukum.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: question on odd APIC behavior
In-Reply-To: <200711162234.54268.oliver@neukum.org>
Message-ID: <Pine.LNX.4.64N.0711191504220.23541@blysk.ds.pg.gda.pl>
References: <200711150054.34312.oliver@neukum.org> <200711161203.29142.oliver@neukum.org>
 <Pine.LNX.4.64N.0711161112440.25869@blysk.ds.pg.gda.pl>
 <200711162234.54268.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Nov 2007, Oliver Neukum wrote:

> I am getting irq 19:nobody cared. Interrupts on 19 and 20 increase with
> same rate, disconnecting the device on the bus stops the increase,
> reconnecting it makes them increase again.

 Very odd indeed.  I suggest you post the relevant information (like the 
bootstrap log, output from `lspci -v', the contents of /proc/cpuinfo, 
etc.) together with the description of the problem (so that the report is 
self-contained) here and perhaps somebody will be able to diagnose it 
properly.  It could be some ACPI breakage.

  Maciej
