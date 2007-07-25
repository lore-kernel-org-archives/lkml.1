Return-Path: <linux-kernel-owner+w=401wt.eu-S1762428AbXGYKPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762428AbXGYKPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 06:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757828AbXGYKOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 06:14:54 -0400
Received: from linux.dunaweb.hu ([62.77.196.1]:60220 "EHLO linux.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650AbXGYKOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 06:14:53 -0400
Message-ID: <46A72284.3090702@dunaweb.hu>
Date: Wed, 25 Jul 2007 12:14:28 +0200
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: NVIDIA libata status outdated
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it seems your "Libata status" page needs some update.

"


      NVIDIA

Driver name: *sata_nv*

Summary: No TCQ/NCQ in early chipsets. NCQ support added in later 
chipsets. Looks like a PATA controller, but with full SATA control 
including hotplug and PM.

*Update:* NVIDIA has provided information (under NDA) that permits 
implementation of NCQ support, and a sample Linux implementation 
<http://www.kernel.org/pub/linux/kernel/people/jgarzik/libata/archive/2.6.17-nv-adma.patch.bz2> 
(patch) as well. Unfortunately, the patch needs debugging, and no one 
seems to have the time or motivation.

*NOTE:* Newer NVIDIA chipsets are AHCI 
<http://linux-ata.org/driver-status.html#ahci>, and use the ahci driver 
rather than the sata_nv driver.
"

There have been changes since you wrote the above.
ADMA has been incorporated mainstream for a while now
and SWNCQ is now in -mm. AHCI support is obvious.

Best regards,
Zoltán Böszörményi


