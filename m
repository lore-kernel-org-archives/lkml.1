Return-Path: <linux-kernel-owner+w=401wt.eu-S1758372AbZDPTX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372AbZDPTX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 15:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757791AbZDPTXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 15:23:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37873 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbZDPTXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 15:23:16 -0400
Message-ID: <49E7859C.2080701@pobox.com>
Date: Thu, 16 Apr 2009 15:23:08 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH #upstream-fixes] pata_legacy: fix no device fail path
References: <19f34abd0804200329j3308b081vc0732c3ec5c0b721@mail.gmail.com> <1208782090.7115.179.camel@twins> <480FF821.9050208@gmail.com> <49E0C102.4020705@pobox.com> <49E22ED9.40100@gmail.com> <49E40A07.6010905@gmail.com>
In-Reply-To: <49E40A07.6010905@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> When pata_legacy can't detect any device, it unregisters the
> platform_device and fails detection.  However, it forgets to detach
> ata host triggering weird failures as the host later gets freed by
> devres while still attached.  Fix it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Peter Zijlstra <peterz@infradead.org>
> ---
> Well, with or without test verification, this patch is correct.  Thanks.
> 
>  drivers/ata/pata_legacy.c |    1 +
>  1 file changed, 1 insertion(+)

applied


