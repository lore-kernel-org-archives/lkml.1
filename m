Return-Path: <linux-kernel-owner+w=401wt.eu-S932933AbXCLBFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbXCLBFF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 21:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbXCLBFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 21:05:04 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:50788 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbXCLBFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 21:05:03 -0400
Date: Mon, 12 Mar 2007 09:03:02 +0800
From: Joe Jin <joe.jin@oracle.com>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Joe Jin <joe.jin@oracle.com>, akpm@osdl.org, dgilbert@interlog.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       haobo.zhou@oracle.com
Subject: Re: [PATCH] [scsi]: Add offline state checking while dispatch a scsi cmd
Message-ID: <20070312010302.GA32372@joejin-pc.cn.oracle.com>
References: <20070308092207.GA17141@joejin-pc.cn.oracle.com> <1173369759.3683.1.camel@mulgrave.il.steeleye.com> <20070309014040.GA6632@joejin-pc.cn.oracle.com> <1173626483.3420.3.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173626483.3420.3.camel@mulgrave.il.steeleye.com>
User-Agent: Mutt/1.4.1i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> This is a bug actually in the megaraid.

Aha, I'll track it.

> 
> And this is a direct command submission path:  it already passed both
> online check gates in this path *after* the device was offlined, so
> adding a third won't fix this. 

Yeah, I have notice that, however, from the logs, the device have offline, 
but why still can send cmd to device? isn't the sequences of printk suspectful?

> single disk, so the I/O was definitely bound for sda?  Secondly, can you
> reproduce with a modern (2.6.20) kernel.  Your trace strongly suggests
> that the device came back online for some reason and then the megaraid
> driver died.

It's hard to update the kernel for the system is a production system, and we
cannot debug it at the box :( 

I dont know if you have notice, the logs come from diskdump, if it caused by
diskdump?

Thanks,
Joe
