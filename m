Return-Path: <linux-kernel-owner+w=401wt.eu-S1761146AbXIJUAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761146AbXIJUAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 16:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbXIJUAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 16:00:00 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44945 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbXIJT76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:59:58 -0400
Date: Mon, 10 Sep 2007 21:59:57 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] mm/memcontrol.c: clenups
In-Reply-To: <Pine.LNX.4.64.0709102158130.5368@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0709102159270.5368@fbirervta.pbzchgretzou.qr>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
 <20070909202548.GW3563@stusta.de> <46E4FEF7.1090308@linux.vnet.ibm.com>
 <Pine.LNX.4.64.0709102158130.5368@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 10 2007 21:58, Jan Engelhardt wrote:
>On Sep 10 2007 13:53, Balbir Singh wrote:
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -91,7 +91,7 @@ enum {
>>>  	MEM_CONTAINER_TYPE_CACHED,
>>>  	MEM_CONTAINER_TYPE_ALL,
>>>  	MEM_CONTAINER_TYPE_MAX,
>>> -} mem_control_type;
>>> +};
>>
>>Not sure about this, is this the preferred style?

Humm. Judging from the @@-line, it looks like:

enum {
	MEM_CONTAINER_TYPE_WHATEVER
} mem_control_type;

making it actually a variable name. Confusing at best.


	Jan
-- 
