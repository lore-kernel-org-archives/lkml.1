Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbYF1Lc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbYF1Lc3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 07:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYF1LcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 07:32:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42114 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbYF1LcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 07:32:19 -0400
Date: Sat, 28 Jun 2008 08:31:54 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       dean@sensoray.com
Subject: Re: [PATCH] add Sensoray 2255 v4l driver
Message-ID: <20080628083154.33d3a93d@gaivota>
In-Reply-To: <20080626231551.GA20012@kroah.com>
References: <20080626231551.GA20012@kroah.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 16:15:51 -0700
Greg KH <greg@kroah.com> wrote:

> From: Dean Anderson <dean@sensoray.com>
> 
> This driver adds support for the Sensoray 2255 devices.
> 
> It was primarily developed by Dean Anderson with only a little bit of
> guidance and cleanup by Greg.
> 

Hmm... there are still a few minor CodingStyle errors:

ERROR: return is not a function, parentheses are not required
#881: FILE: drivers/media/video/s2255drv.c:792:
+       return (dev->resources[fh->channel]);

WARNING: line over 80 characters
#898: FILE: drivers/media/video/s2255drv.c:809:
+       strlcpy(cap->bus_info, dev_name(&dev->udev->dev), sizeof(cap->bus_info));

ERROR: return is not a function, parentheses are not required
#932: FILE: drivers/media/video/s2255drv.c:843:
+       return (0);

ERROR: return is not a function, parentheses are not required
#1053: FILE: drivers/media/video/s2255drv.c:964:
+               return (ret);

ERROR: return is not a function, parentheses are not required
#1428: FILE: drivers/media/video/s2255drv.c:1339:
+       return (0);

ERROR: return is not a function, parentheses are not required
#1452: FILE: drivers/media/video/s2255drv.c:1363:
+                       return (0);

ERROR: return is not a function, parentheses are not required
#1467: FILE: drivers/media/video/s2255drv.c:1378:
+                       return (0);

ERROR: return is not a function, parentheses are not required
#1487: FILE: drivers/media/video/s2255drv.c:1398:
+                               return (-ERANGE);

total: 7 errors, 1 warnings, 2508 lines checked

I'm applying the patch right now on my tree.

Dean,

When you have some time, please send me a patch fixing those.

heers,
Mauro
