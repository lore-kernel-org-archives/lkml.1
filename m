Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbYANTeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbYANTeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbYANTeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:34:14 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:39493 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbYANTeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:34:13 -0500
Date: Mon, 14 Jan 2008 14:34:00 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Possibly silly Q?
To: linux-kernel@vger.kernel.org
Message-id: <200801141434.00934.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings;

Do we have a utility that can force the kernel to re-read, and re-initialize 
itself to a given drives partition tables without having to reboot if one is 
working with a drive that is not part of the required kernel directory tree?

The reason I ask, is that I've just spent about 20 hours fighting with amanda 
after repartitioning a drive for use by amanda as virtual tapes, 
making /dev/sdc1 into a primary partition of nearly 400GB.  /dev/sdc1 started 
out as a /boot2 labeled partition of 200mb, and because the kernels data was 
stale, amanda upchucked all over itself when the kernel thought the original 
200Mb had been filled when it had been umounted from /mnt/bootf8 
repartitioned, mke2fs'd, a journal added and a new label written and then 
mounted to /amandatapes.

Something it seems to me, should have forced the re-init, but didn't.  So is 
there a tool that can force that?

Thanks

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Your mode of life will be changed for the better because of new developments.
