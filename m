Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbXK1NHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbXK1NHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 08:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbXK1NHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 08:07:24 -0500
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:39614 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754522AbXK1NHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 08:07:24 -0500
Message-ID: <474D6801.7040904@linux.vnet.ibm.com>
Date: Wed, 28 Nov 2007 18:37:13 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, gimli@dark-green.com,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc3-mm2 Build Failure at imacfb framebuffer driver 
References: <20071128034140.648383f0.akpm@linux-foundation.org>
In-Reply-To: <20071128034140.648383f0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kernel build fails, with following error

  CC      drivers/video/imacfb.o
drivers/video/imacfb.c: In function ‘imacfb_probe’:
drivers/video/imacfb.c:238: error: ‘struct screen_info’ has no member named ‘imacpm_seg’
make[2]: *** [drivers/video/imacfb.o] Error 1
make[1]: *** [drivers/video] Error 2
make: *** [drivers] Error 2


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
