Return-Path: <linux-kernel-owner+w=401wt.eu-S1759455AbXGCKcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455AbXGCKcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 06:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757533AbXGCKcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 06:32:36 -0400
Received: from pne-smtpout2-sn1.fre.skanova.net ([81.228.11.159]:47000 "EHLO
	pne-smtpout2-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756504AbXGCKcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 06:32:35 -0400
X-Greylist: delayed 4177 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jul 2007 06:32:35 EDT
Date: Tue, 3 Jul 2007 11:22:43 +0200 (CEST)
From: Peter Osterlund <petero2@telia.com>
X-X-Sender: petero@r3000.localdomain
To: Tejun Heo <htejun@gmail.com>
cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, hch@infradead.org
Subject: Re: PKTCDVD related bugzilla bugs
In-Reply-To: <46889817.4050007@gmail.com>
Message-ID: <Pine.LNX.4.64.0707031111320.7564@r3000.localdomain>
References: <46889817.4050007@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2007, Tejun Heo wrote:

> Hello, it's me again.
>
> We have another bug which reportedly is related to pktcdvd.  Please respond.
>
> http://bugzilla.kernel.org/show_bug.cgi?id=7547
> http://bugzilla.kernel.org/show_bug.cgi?id=7805

The problem is that when you run pktsetup, the driver will open the cdrom 
device and keep it open. A very long time ago, the driver didn't do that, 
but that caused other problems, see for example:

 	http://herbie.ucs.indiana.edu/hypermail/linux/kernel/0407.0/0761.html

I don't know how to fix these problems in the kernel, but I know that an 
old idea from Jens Axboe was to merge pktsetup and mount in user space so 
that pktsetup only needs to run when you are actually going to use packet 
writing.

-- 
Peter Osterlund - petero2@telia.com
http://web.telia.com/~u89404340
