Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932408Ab0BYPi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:38:58 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33928 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759190Ab0BYPi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:38:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=riFid56MxDpv4gECDNeV+7OoFexHXTvYj1gDM20Uq3cnDmwYDQguUmWhXXrLuVFRIU
         hm3ytkwO79EBb+ml+l2niPs4ShoXyEdcN0FulNbKpR2WuLO/khe4TEKMh6ujM7aQ0CYq
         Pu1FasljqDH2ZCAVODvDknL2u+xZWfiuwFPhY=
Date: Thu, 25 Feb 2010 23:38:53 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: kernel.h cleanup patchset update for -mm
Message-ID: <20100225153853.GA2659@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, andrew

here is an update version of kernel.h cleanup patchset

changes from first version:
1. bisectable fix
2. style fix
3. make panic/string/printk cleanup standalone patch
4. trace stuff is put into linux/trace.h and include it in kernel.h
5. _HEXDUMP_H change to _LINUX_HEXDUMP_H [Mike Frysinger]

Please drop the following patch in mm tree:
kernelh-printk-panic-string-cleanup.patch
kernelh-intr_sqrt-cleanup.patch

use this series instead in "01/02/03/04/05/06/07" order.

Thanks.

--
Regards
dave
