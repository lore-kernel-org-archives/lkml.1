Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbXC1JaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbXC1JaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 05:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbXC1JaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 05:30:17 -0400
Received: from aa012msr.fastwebnet.it ([85.18.95.72]:36299 "EHLO
	aa012msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbXC1JaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 05:30:15 -0400
Date: Wed, 28 Mar 2007 11:30:06 +0200
From: Paolo Ornati <ornati@fastwebnet.it>
To: Oliver Joa <oliver@j-o-a.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Corrupt XFS -Filesystems on new Hardware and Kernel
Message-ID: <20070328113006.1f4fa0bd@localhost>
In-Reply-To: <460A1D60.4020902@j-o-a.de>
References: <46094344.4090007@j-o-a.de>
	<46096CD7.1010100@mnsu.edu>
	<460A1D60.4020902@j-o-a.de>
X-Mailer: Sylpheed-Claws 2.4.0 (GTK+ 2.10.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Mar 2007 09:46:40 +0200
Oliver Joa <oliver@j-o-a.de> wrote:

> What can be wrong? There is nothing special, only board, cpu and 
> harddisk, no other hardware. The board is running with the newest 
> available bios. I bought a Intel-board, because normally Intel is 
> supported very well.

What Seagate is it?  (hdparm -I /dev/sda | head)

I have this one:

ATA device, with non-removable media
        Model Number:       ST380817AS
        Serial Number:      4MR08EK8
        Firmware Revision:  3.42


and it gives problems with NCQ enabled.

Try turning NCQ off with:

	echo 1 > /sys/block/sda/device/queue_depth

-- 
	Paolo Ornati
	Linux 2.6.20.4 on x86_64
