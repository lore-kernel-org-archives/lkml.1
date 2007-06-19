Return-Path: <linux-kernel-owner+w=401wt.eu-S1758908AbXFSMJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908AbXFSMJj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 08:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757162AbXFSMJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 08:09:32 -0400
Received: from mx0.towertech.it ([213.215.222.73]:32922 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755010AbXFSMJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 08:09:31 -0400
Date: Tue, 19 Jun 2007 14:09:19 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, anemo@mba.ocn.ne.jp,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [rtc-linux] RTC_CLASS is still considered as EXPERIMENTAL?
Message-ID: <20070619140919.0a273429@inspiron>
In-Reply-To: <20070615201959.26666815@inspiron>
References: <20070616.011037.59464869.anemo@mba.ocn.ne.jp>
	<20070615201959.26666815@inspiron>
Organization: Tower Technologies
X-Mailer: Sylpheed
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007 20:19:59 +0200
Alessandro Zummo <alessandro.zummo@towertech.it> wrote:

> On Sat, 16 Jun 2007 01:10:37 +0900 (JST)
> Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:
> 
> > 
> > The generic RTC subsystem was added to kernel 2.6.17 which was
> > released a years ago.  Since then, many drivers were added to the
> > subsystem without major API changes, I think.
> > 
> > It is mature enough to remove EXPERIMENTAL label from RTC_CLASS, isn't
> > it?
> 
>  I'd say yes, I will submit a patch. ty.

 RTC class is mature enough.

 Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>


---
 drivers/rtc/Kconfig |    1 -
 1 file changed, 1 deletion(-)

--- linux-i386.orig/drivers/rtc/Kconfig	2007-06-18 23:43:28.000000000 +0200
+++ linux-i386/drivers/rtc/Kconfig	2007-06-19 14:06:09.000000000 +0200
@@ -10,7 +10,6 @@ config RTC_LIB
 
 config RTC_CLASS
 	tristate "RTC class"
-	depends on EXPERIMENTAL
 	default n
 	select RTC_LIB
 	help
