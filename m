Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbXBFSdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbXBFSdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 13:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933025AbXBFSdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 13:33:14 -0500
Received: from gate.criticalsoftware.com ([212.13.37.242]:21227 "EHLO
	gate.criticalsoftware.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344AbXBFSdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 13:33:14 -0500
X-Greylist: delayed 1633 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Feb 2007 13:33:13 EST
From: Jorge Almeida <j-almeida@criticalsoftware.com>
Reply-To: j-almeida@criticalsoftware.com
Organization: Critical Software
To: linux-kernel@vger.kernel.org
Subject: IRQ Sharing
Date: Tue, 6 Feb 2007 18:01:58 +0000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702061801.58465.j-almeida@criticalsoftware.com>
X-Copyrighted-Material: Please visit http://www.criticalsoftware.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello to all.

I'm running an application that uses several IO boards in a PCI bus.

My main problem is the virtual IRQ sharing between several boards.
I mean for example:
	1 ethernet board IRQ = 169;
	1 ADC card IRQ         = 169;

I want to get ride of this behaviour, and changing the slot position of each 
board is not enought, to get something like (for example):
	1 ethernet board IRQ = 169;
	1 ADC card IRQ         = 170;

Where in the kernel i can see the algorithms for the APIC system where the 
virtual IRQs are distributed? Or exist already any patch that permits to 
solve my problem?

I'm using kernel 2.6.16.27, in a single machine with Intel pentium IV 
processor and chipset ICH4.

Thanks for any reply.
Greetings.

-- 
Jorge Almeida
j-almeida@criticalsoftware.com
DISCLAIMER: This message may contain confidential information or privileged material and is intended only for the individual(s) named. If you are not a named addressee and mistakenly received this message you should not copy or otherwise disseminate it: please delete this e-mail from your system and notify the sender immediately. E-mail transmissions are not guaranteed to be secure or without errors as information could be intercepted, corrupted, lost, destroyed, arrive late or incomplete or contain viruses. Therefore, the sender does not accept liability for any errors or omissions in the contents of this message that arise as a result of e-mail transmissions. Please request a hard copy version if verification is required. Critical Software, SA.
