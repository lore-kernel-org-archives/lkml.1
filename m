Return-Path: <linux-kernel-owner+w=401wt.eu-S965137AbXBQLOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965137AbXBQLOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 06:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965142AbXBQLOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 06:14:38 -0500
Received: from charon.hkfree.org ([89.248.240.1]:52907 "EHLO charon.hkfree.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965137AbXBQLOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 06:14:37 -0500
X-Greylist: delayed 1485 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Feb 2007 06:14:37 EST
Message-ID: <45D6DDCE.5050803@assembler.cz>
Date: Sat, 17 Feb 2007 11:49:50 +0100
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
References: <45D5EA88.7090300@redhat.com>
In-Reply-To: <45D5EA88.7090300@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chuck,

I'm the author of K8temp. Please can you share with us your DSDT table?
(cat /proc/acpi/dsdt > /tmp/dsdt.bin)

> So, could ACPI and the k8temp driver be at odds?

Yes because ACPI AML code has no synchronization with Linux drivers. Second
reason is that ACPI AML code assign resource regions to itself but with cleared
busy flag - so other drivers could bind and might possibly interfere  with ACPI.

This is very long term problem, I already proposed some possible solutions to
this problem
(http://lists.lm-sensors.org/pipermail/lm-sensors/2007-February/018788.html)

There are some ideas, but none is implemented yet. As you already wrote, best
solution is to stop using k8temp driver.

I will check the DSDT table to confirm this fact.

Thanks,
Rudolf
