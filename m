Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608Ab0APX6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab0APX6z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 18:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073Ab0APX6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 18:58:52 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:31424 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab0APX6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 18:58:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:user-agent:date:from:to:cc:subject;
        b=X/Wwpp0e715Lfvv2za57ZUMAfvXZEex598euGxIc6lzxnBdVWKsyWrr6T3UUVdSzBE
         MqiAciYaKzCrANVBKsU77r4t984b2mQl3oR+62ctZh2XjDufESuvg3dCTegM4d7m7qX7
         Ye/advomedKj15EWjks1krzFLNNlFaboqAH6s=
Message-Id: <20100116235653.898098245@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 17 Jan 2010 00:56:53 +0100
From: Bart Hartgers <bart.hartgers@gmail.com>
To: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org
Subject: [patch 0/2] sata_via: bugfixes for vt6420 and vt6421
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

The following patches fix two bugs I encountered in the sata_via
driver.

- DMA/PIO timings for the pata slave drive on a vt6421 were not
handled correctly.  

- ATAPI DMA corruption on a vt6420. At least for some burners, the
vt6420 needs a small delay between sending the CDB and starting DMA to
prevent silent data corruption. I found this solution by experimentation
and while it works great for me, it might not work for everyone. Reports
of success or failure are appreciated.

Some more background is included in the individual patches.

Groeten,
Bart
-- 
