Return-Path: <linux-kernel-owner+w=401wt.eu-S1763547AbXHAJij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763547AbXHAJij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbXHAJib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:38:31 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47995 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbXHAJi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:38:29 -0400
Message-ID: <46B0549A.1010308@bull.net>
Date: Wed, 01 Aug 2007 11:38:34 +0200
From: Zoltan Menyhart <Zoltan.Menyhart@bull.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.3) Gecko/20040913
X-Accept-Language: en-us, en, fr, hu
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
Cc: David Mosberger-Tang <dmosberger@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] flush icache before set_pte take6. [4/4] optimization
 for cpus other than montecito
References: <617E1C2C70743745A92448908E030B2A020E3B1C@scsmsx411.amr.corp.intel.com>
In-Reply-To: <617E1C2C70743745A92448908E030B2A020E3B1C@scsmsx411.amr.corp.intel.com>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 01/08/2007 11:43:16,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 01/08/2007 11:43:18,
	Serialize complete at 01/08/2007 11:43:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luck, Tony wrote:
>>This seems crazy to me.  Flushing should occur according to the
>>*architecture*, not model-by-model.  Even if we happen to get "lucky"
>>on pre-Montecito CPUs, that doesn't justify such ugly hacks.  Or you
>>really want to debug this *again* come next CPU?
> 
> 
> Ditto.  The only reason we should ever have model specific checks should
> be to work around model specific errata (e.g. the McKinley Errata #9 code
> in patch.c).

You do have model specific I cache semantics.
Not taking it into account will oblige you to flush in vain for the models
which do not require it. Why do you want to take this option?


Thanks,

Zoltan
