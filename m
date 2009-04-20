Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbZDTHwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbZDTHwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 03:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZDTHwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 03:52:07 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:57991 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbZDTHwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 03:52:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=tw1QD/ZCnv71yKba8h3cIRr9bXhRKofexiz7ic1OD0/sZVeqhAye2nUDXoHmeNtqCk
         As1soW38eE47kZsX+SHKt+9dXnloWQLWr2qwXDZZrtScwu2YZVXWeWbF3YSqKVHGc+uU
         S7BcjFMXO+r28wf8gje8GGx0ux22IkpXCszy8=
Message-ID: <49EC299D.5020102@gmail.com>
Date: Mon, 20 Apr 2009 16:51:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
CC: Linux IDE <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux SCSI <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/2] ide: Stop disks on reboot for laptop which cuts power
References: <20090418124415.1dc82273@neptune.home> <20090418124558.0426f74c@neptune.home>
In-Reply-To: <20090418124558.0426f74c@neptune.home>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruno Prémont wrote:
> My laptop (Acer Travelmate 660) always cuts the power when rebooting
> which causes the disk to emergency-park it's head.
> 
> Add a dmi check to stop disk as for shutdown on this laptop.

Hmm... yeah, I also noticed this behavior on several machines I have
here.  Most were beta BIOSen.

Maybe it's worth to shutdown drives on reboot on all machines?

Thanks.

-- 
tejun
