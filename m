Return-Path: <linux-kernel-owner+w=401wt.eu-S1765100AbYBVUYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765100AbYBVUYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbYBVUYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:24:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:39773 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbYBVUYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:24:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=PO9R+rCSKtO2rsfXezWj8aygk9zLGxzJXpWAEGmNWHKdI2Wg+pL5EFwmaOnF2J2vaRpEPPltTHi1Sg8u8A8+IUCaXYSLQQlHHRo+E/5uSCb9nrVivs3oSH1NDaFQvWyGIa9HWbq9PC1bWL+eAhfj4q1oIhdkpq0xoIQyy3T88ak=
Date: Fri, 22 Feb 2008 21:22:32 +0100
From: Diego Calleja <diegocg@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: BUG?: "Cannot map mmconfig aperture"
Message-Id: <20080222212232.9c7c8a51.diegocg@gmail.com>
In-Reply-To: <alpine.LFD.1.00.0802212124231.7583@apollo.tec.linutronix.de>
References: <20080220223156.578e0a5d.diegocg@gmail.com>
	<alpine.LFD.1.00.0802210853060.7583@apollo.tec.linutronix.de>
	<20080221164105.145d0cbb.diegocg@gmail.com>
	<alpine.LFD.1.00.0802212124231.7583@apollo.tec.linutronix.de>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 21 Feb 2008 21:26:56 +0100 (CET), Thomas Gleixner <tglx@linutronix.de> escribió:

> Thanks. Nothing new there. Can you please apply the patch below and
> provide the output of the ioremap code ?


[    0.155485] ACPI: bus type pci registered
[    0.155581] PCI: Found Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub with MMCONFIG support.
[    0.160814] ioremap: CPA e0000000 268435456 -12
[    0.162182] PCI: Cannot map mmconfig aperture for segment 0
[    0.162215] PCI: Using configuration type 1
[    0.166956] ACPI: EC: Look up EC in DSDT
[    0.173445] ACPI: Interpreter enabled
