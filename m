Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbXLLDXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbXLLDXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 22:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbXLLDXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 22:23:37 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:35741 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbXLLDXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 22:23:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GvBMUnjNXvW7jN3kUn7NH7GhzI38M112CRwqjCGWp8sMyOS87qqra6BXiZYD5Xf4qMUUMgatnxjPC7io6JqQj6R3yPjO/itw+x1TiULC6vTBeIXaxWfz4PAlP4F18ZmgLh9wU5brr/zGpmcLwmG93jDnwnIbVhPXss35/FaoooQ=
Message-ID: <475F5432.6020405@gmail.com>
Date: Wed, 12 Dec 2007 12:23:30 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: use jiffies conversion functions in scsi_ioctl.c
References: <47561B33.3050607@gmail.com> <20071205202131.GF29561@kernel.dk>
In-Reply-To: <20071205202131.GF29561@kernel.dk>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Dec 05 2007, Tejun Heo wrote:
>> Use msecs_to_jiffies() and jiffies_to_msecs() in scsi_ioctl().
>> Sometimes callers use very large values for e.g. vendor specific media
>> clear command and calculation can overflow.
> 
> Thanks Tejun, applied.

Jens, it seems premature timeout on bug 9346 could be caused by the same
problem.  Can you push this so that it can go into 2.6.24?

-- 
tejun
