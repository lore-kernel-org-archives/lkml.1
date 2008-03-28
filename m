Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbYC1LIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbYC1LIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYC1LID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:08:03 -0400
Received: from smtp.nokia.com ([192.100.105.134]:31141 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbYC1LIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:08:01 -0400
Message-ID: <47ECD0AE.4020301@nokia.com>
Date: Fri, 28 Mar 2008 13:04:14 +0200
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [RFC PATCH 05/26] UBIFS: add file-system build
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>	<1206629746-4298-6-git-send-email-Artem.Bityutskiy@nokia.com> <20080328031246.8c7e849b.akpm@linux-foundation.org>
In-Reply-To: <20080328031246.8c7e849b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 28 Mar 2008 11:07:08.0049 (UTC) FILETIME=[DCFA9010:01C890C3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 27 Mar 2008 16:55:25 +0200 Artem Bityutskiy <Artem.Bityutskiy@nokia.com> wrote:
> 
>> +	/*
>> +	 * Make sure that the log is large enough to fit reference nodes for
>> +	 * all buds plus one reserved LEB.
>> +	 */
>> +	tmp64 = c->max_bud_bytes;
>> +	tmp = do_div(tmp64, c->leb_size);
> 
> do_div() operates on u64, not signed long long.  This will warn on several
> architectures.

Will be fixed, thank you!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
