Return-Path: <linux-kernel-owner+w=401wt.eu-S1422831AbXCOGIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422831AbXCOGIZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 02:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422830AbXCOGIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 02:08:25 -0400
Received: from imx12.toshiba.co.jp ([61.202.160.132]:59344 "EHLO
	imx12.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422831AbXCOGIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 02:08:24 -0400
X-Greylist: delayed 2678 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Mar 2007 02:08:24 EDT
Message-Id: <200703150608.l2F68JY2026403@toshiba.co.jp>
MIME-Version: 1.0
Date: Thu, 15 Mar 2007 15:10:20 +0900
X-Mailer: Denshin 8 Go V32.1.4.5
X-My-Real-Login-Name: a_iguchi; 133.114.92.20
From: Akira Iguchi <akira2.iguchi@toshiba.co.jp>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: (Your message of "Thu, 15 Mar 2007 05:36:07 +0000")
  <20070315053607.GQ4095@ftp.linux.org.uk>
References: <E1HRPb0-0003Eh-OG@ZenIV.linux.org.uk>
 <200703150523.l2F5NelE001987@toshiba.co.jp>
 <20070315053607.GQ4095@ftp.linux.org.uk>
Subject: Re: [PATCH 10/13] BLK_DEV_IDE_CELLEB dependency fix
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al wrote:
>
>Eh...  You still need dependency on IDE=y; otherwise you'll get configs
>with IDE=m, BLK_DEV_IDE_CELLEB=y and those won't link.  BLK_DEV_IDEDMA_PCI
>is selectable just fine with IDE=m.
>
>It's the same problem as with ps3 fb.
>

I'm sorry I missed this case.
Using some configurations, I found BLK_DEV_IDE=y was better.
(I failed to link when IDE=y and BLK_DEV_IDE=m.)


Best regards,
Akira Iguchi
