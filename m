Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbXJYKFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbXJYKFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 06:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbXJYKFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 06:05:33 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:8377 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbXJYKFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 06:05:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=k+KIVUikBX97Syx5MNnbiqfbliA3FYAWSpyIV6yL7J72mjqCcCA9bMq7F3aWu0Fp4ilSCvs7fQ0AITfhrFHM9JCS8XrHNurUT6QAUPCZIiXKuYnB4jXCfBqMhpLp9hkUeQ79fwprcgM4ZIsv7DZbLyd/lLDceOZQNUfll/2xJaA=
Message-ID: <47206A5A.7080306@gmail.com>
Date: Thu, 25 Oct 2007 19:05:14 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Jason Gaston <jason.d.gaston@intel.com>
Subject: Re: What's left in libata-dev.git?
References: <472067FD.3060400@garzik.org>
In-Reply-To: <472067FD.3060400@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> 3) Tejun: libata: implement ata_wait_after_reset()
> 
>     ^^^  Tejun, what case does this solve?  Still needed?

Not needed yet.  It will be necessary to support a weird device (CF 
bridged over SATA) but it's a nice clean up regardless (instead of 
quoting ATADVDR in every reset functions).  Any reason not to put it in?

-- 
tejun
