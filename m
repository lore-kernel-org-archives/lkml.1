Return-Path: <linux-kernel-owner+w=401wt.eu-S1752904AbYIFHIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904AbYIFHIB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 03:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbYIFHHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 03:07:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37058 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYIFHHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 03:07:52 -0400
Date: Sat, 06 Sep 2008 16:06:38 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [RESEND] x86_64: add memory hotremove config option
Cc: Gary Hade <garyhade@us.ibm.com>, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20080906000154.GC18288@one.firstfloor.org>
References: <20080905215452.GF11692@us.ibm.com> <20080906000154.GC18288@one.firstfloor.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080906153855.7260.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I am not sure if I understand why you appear to be opposed to
> > enabling the hotremove function before all the issues related
> 
> I'm quite sceptical that it can be ever made to work in a useful
> way for real hardware (as opposed to an hypervisor para virtual setup
> for which this interface is not the right way -- it should be done
> in some specific driver instead) 
> And if it cannot be made to work then it will be a false promise
> to the user. They will see it and think it will work, but it will
> not.
> 
> This means I don't see a real use case for this feature.

I don't think its driver is almighty.
IIRC, balloon driver can be cause of fragmentation for 24-7 system.

In addition, I have heard that memory hotplug would be useful for reducing
of power consumption of DIMM.

I have to admit that memory hotplug has many issues, but I would like to
solve them step by step.


Thanks.
-- 
Yasunori Goto 


