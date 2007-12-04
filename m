Return-Path: <linux-kernel-owner+w=401wt.eu-S1753152AbXLDK5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbXLDK5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 05:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbXLDK5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 05:57:48 -0500
Received: from smtp4-g19.free.fr ([212.27.42.30]:33343 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbXLDK5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 05:57:47 -0500
Message-ID: <475532A7.1000408@free.fr>
Date: Tue, 04 Dec 2007 11:57:43 +0100
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Is the PCI clock within the spec?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I have an x86 system, running Linux 2.6.22.1-rt9, in which I plug one
or two PCI I/O boards. I had been experiencing complete system lock-ups
until I sent the system to the board manufacturer, and he fixed the
problem. However, he told me that the PCI clock seemed out of spec,
as far as voltage is concerned.

(Disclaimer: my knowledge of PCI is 0.)

The board manufacturer sent me the plot of (what appears to be) voltage
versus time for the PCI clock.

http://linux.kernel.free.fr/plot1.jpg

The system manufacturer sent me a similar plot.

http://linux.kernel.free.fr/plot2.jpg

As far as my understanding goes, the signal should alternate between
0 V and 3.3 V (??). In the second plot, it looks like Vmax ~ 4.6V
and Vmin ~ -1.4V (Pk-Pk(C1)=6.08V might mean peak-to-peak voltage?)

0) What is this C1 both plots mention?
1) Am I reading the plot correctly?
2) Is -1.4V in DC even possible?
3) 4.6V is 1.3V above 3.3V and -1.4V is -1.4V below 0. (Assuming I read 
the numbers correctly) Are these values within the PCI spec? Or are 
these voltages dangerous and / or might cause some problems with some 
PCI boards?

Regards.
