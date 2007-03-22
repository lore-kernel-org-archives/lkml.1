Return-Path: <linux-kernel-owner+w=401wt.eu-S934211AbXCVTpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934211AbXCVTpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934213AbXCVTpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:45:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57064 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934211AbXCVTpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:45:44 -0400
Message-ID: <4602DCE5.2080701@garzik.org>
Date: Thu, 22 Mar 2007 15:45:41 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: genestapp@charter.net
CC: linux-kernel@vger.kernel.org
Subject: Re: SATA: Marvell 88SE6141 kernel support?
References: <1992941410.1174591674270.JavaMail.root@fepweb09>
In-Reply-To: <1992941410.1174591674270.JavaMail.root@fepweb09>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

genestapp@charter.net wrote:
> sorry about it taking so long to get back to you. I noticed it still doesn't 
> work after upgrading to fedora 6 and the newest kernel (at the time) so I thought I'd give your legacy driver a try (if you 
> still have it) I'd love to have those 4 extra sata ports. Just a question with 
> the legacy driver would the performance take a hit? I'd be using the ports to 
> add more disks to raid arrays. 
> 
> kernel version: 2.6.19-1.2911.6.5.fc6:
> linux distro: fedora core 6 64bit
> lspci -v output for marvell sata - 
> 
> 03:00.0 SATA controller: Marvell Technology Group Ltd. Unknown device 6141 (rev 01) (prog-if 81)

If you are only using the SATA side of things, you can probably just add 
the PCI ID to the driver.

Or test the patch found in -mm tree.

	Jeff



