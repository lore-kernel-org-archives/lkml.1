Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZICNTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZICNTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:19:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbZICNTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:19:53 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:55425 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193AbZICNTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:19:52 -0400
Subject: Re: Exporting kmemleak.h to userspace
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <84144f020909022323na828156v4eb9a8497cadaef8@mail.gmail.com>
References: <43e72e890909021729q7c40f907v7a81eaf5c8b73a61@mail.gmail.com>
	 <84144f020909022323na828156v4eb9a8497cadaef8@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 03 Sep 2009 14:18:59 +0100
Message-Id: <1251983939.22485.18.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Sep 2009 13:19:01.0148 (UTC) FILETIME=[1A02A5C0:01CA2C99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-03 at 09:23 +0300, Pekka Enberg wrote:
> On Thu, Sep 3, 2009 at 3:29 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> > I was reviewing kmemleak code and noticed kmemleak.h went exported to
> > userspace under include/linux/kmemleak.h. Do we expect userspace to
> > use this stuff somehow? All relevant kmemleak structs are kept
> > private, I'm curious what userspace apps would use this.
> 
> AFAICT, nobody. Catalin, why is the header exported?

I haven't done anything specifically to export it. It probably gets
included via other files. Is adding #ifdef __KERNEL__ enough to avoid
this problem?

-- 
Catalin

