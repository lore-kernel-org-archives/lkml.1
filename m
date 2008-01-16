Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbYAPC6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbYAPC6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756657AbYAPC6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:58:45 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:37522 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049AbYAPC6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:58:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=bll8r9vb9R42HFmiMdqd/sbiWAiZkmhJIe4Bd7tIKJgUfOqDe/cj+mdlBMsps8azNZSYXYDmtbGnR5h3DLoGmUxgNGUiKGPEqW1fnTQq6aE6RTcPeewOjxBAeRwuXWDj8qhomWB7WFb4nQngMU9Hji+zkQWKNtVP4knxPObpFlY=
Message-ID: <478D72DD.6030107@gmail.com>
Date: Wed, 16 Jan 2008 11:58:37 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, daniel.ritz-ml@swissonline.ch,
       jeff@garzik.org, linux-ide@vger.kernel.org
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk
References: <1200445210549-git-send-email-htejun@gmail.com> <20080115184808.e64aed5e.randy.dunlap@oracle.com>
In-Reply-To: <20080115184808.e64aed5e.randy.dunlap@oracle.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Randy Dunlap wrote:
>>   mprintk_set_header(&mp, KERN_INFO "ata%u.%2u: ", 1, 0);
>>   mprintk_push(&mp, "ATA %d", 7);
>>   mprintk_push(&mp, ", %u sectors\n", 1024);
>>   mprintk(&mp, "everything seems dandy\n");
> 
> Looks pretty good to me except that I would change mprintk_push to
> mprintk_add or mprintk_append (I think that I prefer _add).

I think push and flush sound good when used together but then again the
flush function isn't visible in the interface and push has LIFO ring to
it.  I'm okay with add.  append seems a bit too long.

Thanks.

-- 
tejun
