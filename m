Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbZJ2HCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbZJ2HCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 03:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbZJ2HCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 03:02:44 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:55962 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZJ2HCo (ORCPT
	<rfc822;groupwise-SJayaraman@novell.com;0:0>);
	Thu, 29 Oct 2009 03:02:44 -0400
Message-ID: <4AE93E08.3040506@suse.de>
Date: Thu, 29 Oct 2009 12:32:32 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-2.3 Thunderbird/3.0b4
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>
Subject: Re: nfs broken in net-next?
References: <86802c440910281313h2ca89c94w99121edffbf6ce53@mail.gmail.com>
In-Reply-To: <86802c440910281313h2ca89c94w99121edffbf6ce53@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2009 01:43 AM, Yinghai Lu wrote:
> pk12-3214-189-102:~ # mount -t nfs 10.6.75.100:/data/shared/pxeboot /x
> mount.nfs: rpc.statd is not running but is required for remote locking.
> mount.nfs: Either use '-o nolock' to keep locks local, or start statd.
> 

Is statd running on the server? The in-kernel statd has been replaced by
userspace statd.

> using opensuse11.1
> 
> YH
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Suresh Jayaraman
