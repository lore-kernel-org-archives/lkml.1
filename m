Return-Path: <linux-kernel-owner+w=401wt.eu-S1761319AbYDAVDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761319AbYDAVDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760344AbYDAVBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:01:23 -0400
Received: from main.gmane.org ([80.91.229.2]:42886 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760371AbYDAVBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:01:22 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Matthieu CASTET <castet.matthieu@free.fr>
Subject: Re: [RFC PATCH] UBIFS - new flash file system
Date: Tue, 1 Apr 2008 21:01:09 +0000 (UTC)
Message-ID: <loom.20080401T204425-749@post.gmane.org>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.57.151.96 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080313 Iceape/1.1.9 (Debian-1.1.9-1))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Artem Bityutskiy <Artem.Bityutskiy <at> nokia.com> writes:
Hi,

thanks for this new file system
> UBIFS is stable and very close to be production ready. It was
> tested on OLPC and N810. The development was done on flash simulator
> on a 2-way x86 machine. However, UBIFS needs a good review.
Did you have a chance of testing it with various real flash : old small page
nand flash, very big large page NAND (4GB), ...



> UBIFS mount time is considerably faster as well. For example,
> In case of OLPC we observed 10-15 seconds faster boot time
> comparing to JFFS2 (fast mount, no full media check).
May be you could update your benchmark :
http://osl.sed.hu/wiki/ubifs/index.php/Mount_results doesn't give super result :
1 second mount time on a 64 MB flash with 517.73 BogoMIPS CPU.
What will be the result for a 4GB flash ? 64 seconds ?

Did you do very intensive and long test where you can see bad block appearing on
the flash ?


Speaking of big nand, is UBI/UBI-FS free of 2GB/4GB limit ?

> UBIFS is quite complex because
Is it possible to create small and fast code for read only support in 
bootloader ?


Matthieu

