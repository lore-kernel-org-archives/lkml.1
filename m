Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbXE3KMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbXE3KMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 06:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbXE3KMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 06:12:15 -0400
Received: from eos.fwall.u-szeged.hu ([160.114.120.248]:58998 "EHLO
	eos.fwall.u-szeged.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbXE3KMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 06:12:13 -0400
X-Greylist: delayed 2533 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 May 2007 06:12:13 EDT
Date: Wed, 30 May 2007 11:30:00 +0200 (CEST)
From: Geller Sandor <wildy@petra.hos.u-szeged.hu>
To: linux-kernel@vger.kernel.org
Subject: HPT374 IDE problem with 2.6.21.* kernels
Message-ID: <Pine.LNX.4.62.0705301112170.1260@petra.hos.u-szeged.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SZTE-local: YES
X-SZTE-HU-local: YES
X-SZTE-AVcheck: YES
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I saw a similar report yesterday with '2.6.21.1 - 97% wait time on IDE 
operations' subject.

After upgrading from 2.6.20.7 kernel to 2.6.21.1 my system started to 
reset infrequenly the IDE bus. In the syslog DMA timeout, resetting IDE 
bus messages appeared. I've changed the two disks attached to the HPT374 
controller, and always the first disk had problems. I've replaced cables, 
plugged the disks into other IDE ports, but it was only a matter of time 
to experience an IDE reset. When I upgraded to 2.6.21.3 the resets became 
much more frequent, this time even DMA was disabled too on the first disk. 
I turned DMA back Manually with hdparm, and a few seconds of intense IO 
activity resulted in another IDE reset.

Reverting back to 2.6.20.12 the problem seems to be gone. BTW I'm using 
the PATA driver for the HTP374, not the libata one.

Is this a known problem/ is there a way I can help locating the cause of 
the problem?

Regards,

   Geller Sandor <wildy@petra.hos.u-szeged.hu>
