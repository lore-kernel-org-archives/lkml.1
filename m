Return-Path: <linux-kernel-owner+w=401wt.eu-S1030283AbXAYQcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030283AbXAYQcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 11:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030316AbXAYQcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 11:32:09 -0500
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:56042 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030283AbXAYQcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 11:32:06 -0500
Message-ID: <45B8DC2F.2090906@bull.net>
Date: Thu, 25 Jan 2007 17:34:55 +0100
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 4/6] min and max kobjects
References: <20070116061516.899460000@bull.net>	<20070116063029.862885000@bull.net> <20070124144148.8b164cc1.randy.dunlap@oracle.com>
In-Reply-To: <20070124144148.8b164cc1.randy.dunlap@oracle.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 25/01/2007 17:32:55,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 25/01/2007 17:32:57,
	Serialize complete at 25/01/2007 17:32:57
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Tue, 16 Jan 2007 07:15:20 +0100 Nadia.Derbey@bull.net wrote:
> 
> 
>>[PATCH 04/06]
>>
>>Introduces the kobjects associated to each tunable min and max value
>>

<snip>

>>Index: linux-2.6.20-rc4/kernel/autotune/akt.c
>>===================================================================
>>--- linux-2.6.20-rc4.orig/kernel/autotune/akt.c	2007-01-15 15:13:31.000000000 +0100
>>+++ linux-2.6.20-rc4/kernel/autotune/akt.c	2007-01-15 15:25:35.000000000 +0100
>>@@ -203,5 +207,121 @@ ssize_t store_tuning_mode(struct auto_tu
>> }
>> 
>> 

<snip>

>>+
>>+/*
>>+ * FUNCTION:    Set operation called by tunable_attr_store (i.e. when a
>>+ *              string is stored into /sys/tunables/<tunable>/min).
>>+ *
>>+ * PARAMETERS:  count: input buffer size (including the '\0')
>>+ *
>>+ * RETURN VALUE: >0: number of characters used from the input buffer
>>+ *               <= 0: failure
> 
> 
> I would expect a return value of 0 not to indicate failure;
> only <0 should do that.  So is this a typo or a real case where
> a return of 0 indicates failure?

This is a typo

> 
> 
>>+ */
>>+ssize_t store_tunable_min(struct auto_tune *tun_addr, const char *buf,
>>+			size_t count)
>>+{


<snip>

>>+/*
>>+ * FUNCTION:    Set operation called by tunable_attr_store (i.e. when a
>>+ *              string is stored into /sys/tunables/<tunable>/max).
>>+ *
>>+ * PARAMETERS:  count: input buffer size (including the '\0')
>>+ *
>>+ * RETURN VALUE: >0: number of characters used from the input buffer
>>+ *               <= 0: failure
> 
> 
> same question.

Same answer ;-)

> 
> 


Regards,
Nadia

