Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbXIENx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbXIENx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 09:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbXIENxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 09:53:52 -0400
Received: from alpha.facton.com ([83.236.152.122]:45062 "EHLO alpha.facton.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265AbXIENxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 09:53:51 -0400
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Sep 2007 09:53:51 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: 2.4.35.1 md problem
Date: Wed, 5 Sep 2007 15:45:45 +0200
Message-ID: <3C59DB883F7B0B4D8096010D45ACCD134F1D24@exch.facton.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.4.35.1 md problem
Thread-Index: AcfvwwyW+kwAlSPwTo6SNsW8lGAfOw==
From: "Beschorner Daniel" <Daniel.Beschorner@facton.com>
To: <linux-kernel@vger.kernel.org>
Cc: <w@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I got a strange problem after I updated from 2.4.34.4 to 2.4.35.1:

The kernel raid autodetection assembles my 2 raid-1 arrays, but mdstat
shows "0 blocks" for each md.
So the filesystem check complains about no valid superblock, but the
arrays seem to run fine.
After raidstop/raidstart the blocks are displayed correctly and all is
fine.
But this is no solution, because the root fs is raid.

Could it be a compiler issue, I assume there is no change in raid since
2.4.34?!?

I use GCC 4.1.2 and no LVM.

Thanks
Daniel
