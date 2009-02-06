Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbZBFSuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbZBFSuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 13:50:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbZBFSum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 13:50:42 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:54905 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbZBFSum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 13:50:42 -0500
Message-ID: <498C8681.3070205@ct.jp.nec.com>
Date: Fri, 06 Feb 2009 10:50:41 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] sched_rt: protect rt_rq->rt_time by rt_runtime_lock
References: <498B77F6.4020702@ct.jp.nec.com>	 <498B7862.2040004@ct.jp.nec.com> <1233878343.4620.44.camel@laptop> <498B7F13.7040104@ct.jp.nec.com>
In-Reply-To: <498B7F13.7040104@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto wrote:
> Peter Zijlstra wrote:
>> On Thu, 2009-02-05 at 15:38 -0800, Hiroshi Shimamoto wrote:
>>> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>>
>>> Impact: fix possible race condition
>>>
>>> rt_rq->rt_time should be protected.
>> Don't think so, all we do is check the value for non-zero outside the
>> lock, that should be ok.

OK, now I see. I didn't find any real race.

Thanks,
Hiroshi
