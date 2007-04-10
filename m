Return-Path: <linux-kernel-owner+w=401wt.eu-S1031030AbXDJQWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031030AbXDJQWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 12:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031033AbXDJQWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 12:22:12 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:53657 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031030AbXDJQWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 12:22:11 -0400
Message-ID: <461BB9CA.5010806@free.fr>
Date: Tue, 10 Apr 2007 18:22:34 +0200
From: John <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, tglx@timesys.com,
       John <linux.kernel@free.fr>
Subject: Re: 2.6.20-rt8 patch tweaked for 2.6.20.5
References: <461672D8.7090100@free.fr> <20070406173639.GA2929@elte.hu> <461B53CD.1030603@free.fr> <20070410131724.GA18553@elte.hu> <461B9CA6.8030707@free.fr> <20070410142302.GA1519@elte.hu>
In-Reply-To: <20070410142302.GA1519@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> John wrote:
> 
>> Great! Can you tell me how you generate the original -rt patch, so I 
>> can provide an updated version when a new 2.6.20 kernel is released?
> 
> they should be generated the way you did: apply the 2.6.20 baseline -rt 
> kernel patch to the later patches and fix up rejects. For later kernels 
> just do the same.

What options do you give diff?

The output of your patch is e.g.

Index: linux/drivers/input/gameport/gameport.c
===================================================================
--- linux.orig/drivers/input/gameport/gameport.c
+++ linux/drivers/input/gameport/gameport.c
@@ -21,6 +21,7 @@
  #include <linux/slab.h>
  #include <linux/delay.h>
  #include <linux/kthread.h>
+#include <linux/interrupt.h>
[...]


diff -upr gives me, e.g.

diff -upr linux-2.6.20.5/drivers/input/gameport/gameport.c 
linux-2.6.20.5-rt8/drivers/input/gameport/gameport.c
--- linux-2.6.20.5/drivers/input/gameport/gameport.c    2007-04-06 
12:44:59.000000000 +0200
+++ linux-2.6.20.5-rt8/drivers/input/gameport/gameport.c 
2007-04-06 18:09:48.000000000 +0200
@@ -21,6 +21,7 @@
  #include <linux/slab.h>
  #include <linux/delay.h>
  #include <linux/kthread.h>
+#include <linux/interrupt.h>
[...]

How do I get diff not to print the file time stamps?

How do I get diff not to print the command line for each file?

Regards.
