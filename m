Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbYDIPvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbYDIPvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 11:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbYDIPvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 11:51:40 -0400
Received: from mx0.towertech.it ([213.215.222.73]:55298 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752737AbYDIPvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:51:40 -0400
Date: Wed, 9 Apr 2008 17:51:37 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] Re: build issue #470 for v2.6.25-rc8-166-g6fdf5e6
 :rtc-s35390a.c:144: undefined reference to `byte_rev_table'
Message-ID: <20080409175137.727807b1@i1501.lan.towertech.it>
In-Reply-To: <20080409084819.78eaa342.randy.dunlap@oracle.com>
References: <200804090957.55929.toralf.foerster@gmx.de>
	<20080409084819.78eaa342.randy.dunlap@oracle.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2008 08:48:19 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> rtc-s35390a uses BITREVERSE functions so it needs to select that
> config symbol to ensure that the functions are built.
> 
> drivers/built-in.o: In function `s35390a_set_datetime':
> linux-2.6.25-rc8-git7/drivers/rtc/rtc-s35390a.c:144: undefined reference to `byte_rev_table'
> drivers/built-in.o: In function `s35390a_get_datetime':
> linux-2.6.25-rc8-git7/drivers/rtc/rtc-s35390a.c:163: undefined reference to `byte_rev_table'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

 thanks Randy.


 Acked-by: Alessandro Zummo <a.zummo@towertech.it>

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

