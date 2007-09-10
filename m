Return-Path: <linux-kernel-owner+w=401wt.eu-S1761294AbXIJT7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294AbXIJT7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbXIJT64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:58:56 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44934 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363AbXIJT6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:58:55 -0400
Date: Mon, 10 Sep 2007 21:58:53 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] mm/memcontrol.c: clenups
In-Reply-To: <46E4FEF7.1090308@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0709102158130.5368@fbirervta.pbzchgretzou.qr>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
 <20070909202548.GW3563@stusta.de> <46E4FEF7.1090308@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 10 2007 13:53, Balbir Singh wrote:
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -91,7 +91,7 @@ enum {
>>  	MEM_CONTAINER_TYPE_CACHED,
>>  	MEM_CONTAINER_TYPE_ALL,
>>  	MEM_CONTAINER_TYPE_MAX,
>> -} mem_control_type;
>> +};
>> 
>
>Not sure about this, is this the preferred style?

Yes, typedefs are bad. And because it happens very so often,
I also have the link: http://lkml.org/lkml/2006/11/21/34



	Jan
-- 
