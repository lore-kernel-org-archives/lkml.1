Return-Path: <linux-kernel-owner+w=401wt.eu-S934124AbXC0Sex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934124AbXC0Sex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934140AbXC0Sex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:34:53 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:59734 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934124AbXC0Sev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:34:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TV+qhOKQFu5fjPrA6ROS5IPxZfKkvm36bcTclMl191NTOILDeRjvsyhkLx87URyfXsAjP/6aU3rktToKPYlga2ktOtNZriFa/jviNKtlUtPHCR1XhgVjzJfR3v/WdZIqYY2fd99Q3JTocNQWMqdSQqTN3faynCwgEO08YBp+hFE=
Message-ID: <6bffcb0e0703271134i328af6feu47a780d143ebe046@mail.gmail.com>
Date: Tue, 27 Mar 2007 20:34:50 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc5
Cc: "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Pavel Machek" <pavel@ucw.cz>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 26/03/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
> There's various fixes here, ranging from some architecture updates (ia64,
> ARM, MIPS, SH, Sparc64) to KVM, networking and network drivers.
>

Suspend to disk doesn't work for me with this patch. It hangs after
PM: Preparing devices for restore.
Suspending console(s)
during resuming.

a504e64ab42bcc27074ea37405d06833ed6e0820 is first bad commit
commit a504e64ab42bcc27074ea37405d06833ed6e0820
Author: Stephen Hemminger <shemminger@linux-foundation.org>
Date:   Fri Feb 2 08:22:53 2007 -0800

    skge: WOL support

    Add WOL support for Yukon chipsets in skge device.

    Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
    Signed-off-by: Jeff Garzik <jeff@garzik.org>

:040000 040000 d3d4335e6cba330b7880b4787fbe48733e69f8fc
5845b004228d811de912a55da6a7843b72f23f81 M      drivers

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc5/git-config2

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
