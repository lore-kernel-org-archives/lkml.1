Return-Path: <linux-kernel-owner+w=401wt.eu-S1750977AbXCRU5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750977AbXCRU5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 16:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbXCRU5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 16:57:33 -0400
Received: from server077.de-nserver.de ([62.27.12.245]:50660 "EHLO
	server077.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbXCRU5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 16:57:32 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Mar 2007 16:57:31 EDT
Message-ID: <45FDA626.9000404@prie.be>
Date: Sun, 18 Mar 2007 21:50:46 +0100
From: Stefan Priebe <stefan@prie.be>
User-Agent: Mozilla Thunderbird 1.0.7 (Windows/20050923)
X-Accept-Language: de-DE, de, en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Kernel 2.6.20 does not work anymore with SCSI or SATA on old Opteron
 / Xeon servers
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 91.3.42.221
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

We've a very strange Problem with Kernel 2.6.20.x

If i try to access a SCSI or SATA Disk (tested with Adaptec U320 
ASC-29320, ICP Vortex 9024, Promise TX300) the whole server hangs - no 
output - no error on the screen - but it hangs completely. But it does 
not happen on all our systems affected are only old 604pin xeons and 
socket 940 Opterons. Socket F Opteron or 771 Xeons does work fine.

I've also testet apci=off pci=routeirq but both does not help. The 
systems work fine with 2.6.19.x and before.

Stefan
