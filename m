Return-Path: <linux-kernel-owner+w=401wt.eu-S1760094AbYCBWje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094AbYCBWje (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 17:39:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbYCBWj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 17:39:27 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:28666 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbYCBWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 17:39:26 -0500
Date: Sun, 2 Mar 2008 14:37:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matt Reuther <mreuther@umich.edu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24.3 Error During Compile
Message-Id: <20080302143735.241a50a0.randy.dunlap@oracle.com>
In-Reply-To: <200803021303.50181.mreuther@umich.edu>
References: <200803021303.50181.mreuther@umich.edu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Mar 2008 13:03:49 -0500 Matt Reuther wrote:

> I get the following error when I compile a vanilla 2.6.24.3 kernel:
> 
>   UNIFDEF include/linux/hayesesp.h
>   UNIFDEF include/linux/hdlc.h
>   UNIFDEF include/linux/hdlcdrv.h
>   UNIFDEF include/linux/hdreg.h
>   UNIFDEF include/linux/hiddev.h
>   UNIFDEF include/linux/hpet.h
>   UNIFDEF include/linux/i2c.h
>   UNIFDEF include/linux/i2o-dev.h
>   UNIFDEF include/linux/icmp.h
>   UNIFDEF include/linux/icmpv6.h
>   UNIFDEF include/linux/if_addr.h
> make[3]: *** No rule to make target 
> `/usr/local/src/linux-2.6.24.3/include/linux/if_addrlabel.h', needed by 
> `/usr/local/src/linux-2.6.24.3/usr/include/linux/if_addrlabel.h'.  Stop.
> make[2]: *** [linux] Error 2
> make[1]: *** [headers_install] Error 2
> make: *** [vmlinux] Error 2
> 
> My .config is attached. I carried over my .config from 2.6.23.12, and 
> ran 'make menuconfig' on it to update the options.
> 
> Please let me know if I need to provide any more info.

Already reported.  The patch that caused it will be reverted.

---
~Randy
