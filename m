Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbZKEFmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbZKEFmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 00:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755110AbZKEFmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 00:42:21 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59583 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953AbZKEFmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 00:42:21 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Darren Hart <dvhltc@us.ibm.com>
Subject: Re: [RFC][PATCH] Add prctl to set sibling thread names
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Mike Fulton <fultonm@ca.ibm.com>, Sean Foley <Sean_Foley@ca.ibm.com>
In-Reply-To: <4AF26471.6010705@us.ibm.com>
References: <20091105141953.2090.A69D9226@jp.fujitsu.com> <4AF26471.6010705@us.ibm.com>
Message-Id: <20091105143959.2093.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  5 Nov 2009 14:42:23 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> KOSAKI Motohiro wrote:
> >> KOSAKI Motohiro wrote:
> >>
> >>> John, I'd prefer to suggested another design.
> >>> How about this?
> >>>
> >>> 1. remove pid argument from prctl
> >>> 2. cancel pthread_setname_np()
> >>> 3. instead, create pthread_attr_setname_np()
> >>> 4. pthread_create() change own thread name by pthread_attr.
> >>>
> >>> It avoid many racy problem automatically.
> >> Perhaps, but it also greatly reduces the flexibility of the 
> >> implementation by restricting name changes to create time.
> > 
> > Hm.
> > if your program really need to change another thread name, can you please tell us
> > why it is necessary and when it is used?
> 
> I think John's previous mails covered that pretty well. As for doing the 
> name change at create time, or sometime later, it just seems to me that 
> the flexibility of doing so later is worth having. While I know we don't 
> have to follow other systems implementations, in this case 
> pthread_setname_np() seems a reasonable model to follow to me.

You only said your mode is more flexible. but I want to know _why_ this flexibiliby is
necessay. please tell us concrete use-case.


