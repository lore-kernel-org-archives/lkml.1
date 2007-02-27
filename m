Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbXB0Utu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbXB0Utu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbXB0Utu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:49:50 -0500
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:35403 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbXB0Uts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:49:48 -0500
Date: Tue, 27 Feb 2007 22:49:45 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: 2.6.21-rc1: more ACPI errors (EC__)
Message-ID: <Pine.SOC.4.64.0702260842260.9705@math>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I tested 2.6.21-rc1 on my laptop (IBM X20 with 440BX) and found two 
problems:

First, a seemingly harmless one - ACPI error messages during bootup:

ACPI Exception (evregion-0420): AE_NOT_FOUND, Returned by Handler for [EmbeddedControl] [20070126]
ACPI Exception (dswexec-0462): AE_NOT_FOUND, While resolving operands for [OpcodeName unavailable] [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.ISA_.EC__.BAT0._STA] (Node d3c435e0), AE_NOT_FOUND
ACPI Exception (evregion-0420): AE_NOT_FOUND, Returned by Handler for [EmbeddedControl] [20070126]
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.ISA_.EC__.AC__._PSR] (Node d3c43540), AE_NOT_FOUND
ACPI Exception (ac-0095): AE_NOT_FOUND, Error reading AC Adapter state [20070126]

And second, there were ACPI error messages about EC__ during shutdown. 
These messages appeared, then the "acpi_power_off called" message 
appeared, then it waited for about 5 seconds (this does not happen 
normally) and then it succeeded shutting down. Captured a screenshot of 
these messages, temporarily available at 
http://www.cs.ut.ee/~mroos/x20-shutdown-acpi-errors.jpg

-- 
Meelis Roos (mroos@linux.ee)
