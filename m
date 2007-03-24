Return-Path: <linux-kernel-owner+w=401wt.eu-S1751592AbXCXAar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbXCXAar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 20:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbXCXAar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 20:30:47 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33111 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751675AbXCXAaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 20:30:46 -0400
Date: Sat, 24 Mar 2007 01:30:49 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc regression in mptbase
Message-ID: <20070324003049.GA752@stusta.de>
References: <Pine.LNX.4.61.0703232322030.10028@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0703232322030.10028@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 11:39:12PM +0100, Jan Engelhardt wrote:
> Hello world,
> 
> 
> in at least 2.6.21-rc4, one or more of the mptscsi scsi modules is 
> broken with respect to not detecting any harddisk (VMware provides that 
> virtual LSI MPT controller), which means no working system.
> No problems in 2.6.20.2.
>...

Could be a bug in the driver or a bug in the emulation exposed by a 
change in the driver.

Can you bisect which change to the driver broke it?

> Jan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

