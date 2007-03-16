Return-Path: <linux-kernel-owner+w=401wt.eu-S965955AbXCPVQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965955AbXCPVQE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 17:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965953AbXCPVQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 17:16:03 -0400
Received: from mail05.syd.optusnet.com.au ([211.29.132.186]:51205 "EHLO
	mail05.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965954AbXCPVQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 17:16:00 -0400
From: Con Kolivas <kernel@kolivas.org>
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: [PATCH][RSDL-mm 4/6] sched: dont renice kernel threads
Date: Sat, 17 Mar 2007 08:29:47 +1100
User-Agent: KMail/1.9.5
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200703170054.08641.kernel@kolivas.org> <45FAB458.2080304@nortel.com>
In-Reply-To: <45FAB458.2080304@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703170829.47810.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2007 02:14, Chris Friesen wrote:
> Con Kolivas wrote:
> > The practice of renicing kernel threads to negative nice values is of
> > questionable benefit at best, and at worst leads to larger latencies when
> > kernel threads are busy on behalf of other tasks.
>
> What about the priority implications of the renicing?  It seems a bit
> iffy letting kernel threads compete for cpu time on an equal basis with
> your default shell.

Lots of things we do because we just assume they're a good idea without any 
evidence. Renicing kernel threads was always considered a good idea on this 
basis. I'm certain noone has ever proven that it's a good thing though. 
Either way, the latest version of rsdl is robust enough that it works fine 
with reniced kernel threads if you still believe that's advantageous. This is 
definitely open for discussion/opinion.

-- 
-ck
