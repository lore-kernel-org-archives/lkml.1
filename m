Return-Path: <linux-kernel-owner+w=401wt.eu-S1751559AbXDXIFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbXDXIFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbXDXIFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:05:22 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:31754 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbXDXIFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:05:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mu2AXPTy3Ezsx4MGMJ+IuRx71nvhOZmvKZSQoHdx/OnTGezXp3JPAn58NKSWgLw3+Otbjc8BVZoJfPoB1LQahMBoqr3a3Kq/v508D895AFbDSwVK01vb2arLIlNHtTP2x0DXlhd0IJIoSQ+SBGSMf2V6hhjeDjGrUaGio2PpTIQ=
Message-ID: <462DBA33.9060207@gmail.com>
Date: Tue, 24 Apr 2007 17:05:07 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [patch 2/7] genhd: expose AN to user space
References: <20070424074856.005152262@intel.com> <20070423165950.7d64bd8e.kristen.c.accardi@intel.com>
In-Reply-To: <20070423165950.7d64bd8e.kristen.c.accardi@intel.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> +static struct disk_attribute disk_attr_capability = {
> +	.attr = {.name = "capability_flags", .mode = S_IRUGO },
> +	.show	= disk_capability_read
> +};

How about just "capability"?  I think that would be more consistent with
other attributes.

-- 
tejun
