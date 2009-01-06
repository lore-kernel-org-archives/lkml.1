Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbZAFJgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbZAFJgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbZAFJg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:36:29 -0500
Received: from n61.bullet.mail.sp1.yahoo.com ([98.136.44.37]:40225 "HELO
	n61.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751226AbZAFJg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:36:28 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 67299.50093.bm@omp408.mail.sp1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Message-ID;
  b=y6Mr8Sxy2+K/wqos56RcthOjxPql2ZlbsU4IptOlz/sQMb/n/3ih2YZjNGF1U2aiOUPSHRJqSHLM4RbIYmEMN2OZN6cE3FmS5RdQKJXbUUuUgJL6tVodRIwuAfdq6zyrwqK4+ze6fE1hCeig+KkUGC1WfW6Zb15ToGtr5Gbxnc0=;
X-YMail-OSG: Cu9P76IVM1kX7BdKH2hNxeTb_9reGNV86kDZ4Ep5lbYh2RKsiOVl.1ec66Pqf5xXArfevm3.rnIc9x6RHxiImla7eTP2LZRU6L.Ez5TAQJqvRCaHrfhnUOtH6VZfl.PN_uva87b87nInLYNljzUwhPT3h9g-
X-Mailer: YahooMailWebService/0.7.260.1
Date: Tue, 6 Jan 2009 01:36:27 -0800 (PST)
From: barry bouwsma <free_beer_for_all@yahoo.com>
Reply-To: free_beer_for_all@yahoo.com
Subject: EHCI problem with USB adapter
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <971780.75725.qm@web46108.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moin moin,

I have a machine with a recent 2.6.28-rc, that stubbornly
refuses to work well with three PCI USB cards and one
particular USB WLAN adapter.  Use of a USB flash drive is
somewhat better, while when booting into NetBSD from Sep
of last year, two of the three cards have no problem
recognizing the USB WLAN adapter -- the third card fails
to be seen and probably needs me to reconfigure my NetBSD
kernel, being a strange card with onboard bridge.  These
problems seem to be identical over several kernel versions.
As NetBSD works, I don't expect the problem to be inherent
in the hardware.  Also, the device attached properly with
an EHCI card on a notebook.


Is this most likely to be a fault of the Linux USB EHCI
stack, or would the WLAN adapter driver code be suspect,
so that I could post to a narrower-interest mailing list?

I should probably try attaching different devices to be
able to say what does and what doesn't work...


Some background info:
I've pulled an ISA network card from the machine, as it
was seen to be causing issues.  Likewise, I've pulled the
other PCI card out, in case it would affect anything.

Sometimes, after a period of time, the EHCI adapter will
hand off to the U/OHCI USB1 adapter which successfully
attaches, but not always, and only on one port.

With one particular card, attaching the wireless adapter
causes the number of interrupts on that IRQ to shoot up
rapidly and continuously, until everything dies.

A different machine in production has a fourth USB PCI
card which has been working reliably there for those
devices attached to it, though I haven't tried the
problematic WLAN adapter there... (much older kernel)


I'll be spending some time gathering data and details on
how each card interacts with different devices, and how
NetBSD handles those cases which cause problems with
Linux, to see if I can make it possible to attach this
particular device reliably.

thanks,
barry bouwsma


      

