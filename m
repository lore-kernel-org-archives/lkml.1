Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612Ab0A0P0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0A0P0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 10:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329Ab0A0P0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 10:26:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:29142 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab0A0P0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 10:26:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=xRDPYsv3Hd8dQbgeg13aGOQqzISyWHZqwy1vxTzit1Vw/4jozR0LzL/JfjstARspRj
         f4Sy0xKM1dox/JftGj6xHqpu9QjwJjfi3AkkQyThopUWd5lso++A50fUN6zNjphuzWX7
         VN4pG8pFbsyQarP8ixUqVrI0vuzp5xR1Ee4d8=
Message-ID: <4B605B05.7060601@gmail.com>
Date: Wed, 27 Jan 2010 16:25:57 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.7) Gecko/20100111 SUSE/3.0.1-9.1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, bzolnier@gmail.com, jens.axboe@oracle.com,
       marcin.slusarz@gmail.com, shemminger@vyatta.com
Subject: Re: + drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch
 added to -mm tree
References: <201001270037.o0R0bqQC032566@imap1.linux-foundation.org>	 <4B600AB7.3070705@gmail.com> <1264603993.14552.71.camel@Joe-Laptop.home>
In-Reply-To: <1264603993.14552.71.camel@Joe-Laptop.home>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2010 03:53 PM, Joe Perches wrote:
> Do feel free to submit patches with your
> desired level of changelog prolixity.

It's not my level changelog prolixity, it's you do changes irrelevant to
your changelog and further you do not explain, why you change the code.
So (a) review process is hard and (b) nobody (mainly distro kernel
packagers) knows whether to backport some of the change to stable or not.

Look at that piece again:
Subject	[PATCH 03/24] drivers/block/floppy.c: Use pr_<level>
Date	Thu, 21 Jan 2010 20:52:33 -0800

Convert bare printk to pr_info and pr_cont
Convert printk(KERN_ERR to pr_err
...
 	if (UDP->flags & FD_DEBUG) {
-		DPRINT("reschedule timeout ");
-		printk(message, marg);
-		printk("\n");
+		DPRINT("reschedule timeout %s %d\n", message, marg);
 	}

Does it look like a "Use pr_<level>" change? No and hence my confusion
by the hunk.

-- 
js
