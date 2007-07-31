Return-Path: <linux-kernel-owner+w=401wt.eu-S1753807AbXGaIIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbXGaIIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 04:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbXGaIH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 04:07:56 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:37345 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327AbXGaIHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 04:07:51 -0400
Message-ID: <46AEED9E.1050904@free.fr>
Date: Tue, 31 Jul 2007 10:06:54 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: BIOS implementors disabling the LAPIC
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have several systems here where Linux tells me:
Local APIC disabled by BIOS -- you can enable it with "lapic"

As far as I understand, the Local APIC was integrated directly to the 
CPU 12-15 years ago. Why would a BIOS implementor choose to disable it?

(And what does it mean to "disable" the LAPIC?)

Note: the motherboard does not provide an IO-APIC.

I've ask the kernel to re-enable the LAPIC, and was able to use OProfile 
in hardware counter mode, i.e. it seems to work fine.

Regards.
