Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbXIHRHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbXIHRHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 13:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753797AbXIHRH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 13:07:29 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:42612 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbXIHRH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 13:07:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=uZJkmRi7wi4vFHytXhU1d36vQx+XmARCdhjve9Iemwu1lYzw926ie3tiZxJnDuLe5z6xa3jTEcYn49b8bGAUl6LJ9V3xNW8bo9h6MVxxMB6yoDatWknpZiQS2Tu8maYJDANt1yk/4q7WcXJoBVnV4YkTFbWNhdz9UJQ1jYlzROE=
Message-ID: <46E24DE8.4050603@gmail.com>
Date: Sat, 08 Sep 2007 16:23:20 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Paul Rolland <rol@as2917.net>
CC: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [2.6.22.5] irq X: nobody cared but X is successfully used by
 libata
References: <20070826203513.4fa35f68@tux.DEF.witbe.net>
In-Reply-To: <20070826203513.4fa35f68@tux.DEF.witbe.net>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Rolland wrote:
> Hello,
> 
> My machine (an ASUS P5W-DH-Deluxe, Core2, 4Go RAM, 3 SATA and 2IDE) is
> reporting a :
> irq 23: nobody cared (try booting with the "irqpoll" option)
> together with a Call Trace, but :
>  - irqpoll is present on the command line,
>  - the irq is reported to be used by libata,
>  - the irqpoll option is mandatory if I want _some_ of my SATA disks to be 
>    accessible.

So, if you don't add the 'irqpoll' option, IO to disks don't work at all
after nobody cared message, right?

-- 
tejun

