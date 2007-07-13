Return-Path: <linux-kernel-owner+w=401wt.eu-S1761855AbXGMMzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761855AbXGMMzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 08:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758674AbXGMMyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 08:54:47 -0400
Received: from mx01.hansenet.de ([213.191.73.25]:46657 "EHLO
	webmail.hansenet.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758487AbXGMMyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 08:54:46 -0400
Message-ID: <4697760E.4070803@e-dict.net>
Date: Fri, 13 Jul 2007 14:54:38 +0200
From: Ingo Freund <linux-kernel-news@e-dict.net>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: howto create partitions bigger than 2TB 
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I've got a RAID5 (driver aacraid for an ICP9047MA) with four
750GB hdds which provides a 2.25TB sized device.
None of the until now used tools will work with that device.
fdisk complains about missing cylinder count.
cfdisk misses the device size.
parted shows the right device size but only creates a partion
with 51GB.
What am I supposed to do to work with this device?
Which fs can handle it?
(CONFIG LARGE BLOCK is on)
We are talking about a 32Bit machine with vanilla kernel 2.6.21.5.

Thanks in advance,
Regards - Ingo.
