Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYGKFXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYGKFXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 01:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYGKFXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 01:23:21 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:34452 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbYGKFXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 01:23:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fHD0xuWXPbHVxw/sZBZQ75BrLM6dAuhKimNLnWr5yiPH7bAV1YfNtBqlugmL2STaHr
         Z+oFI1Dn1PmZw4C9OEiTOGpcBxBdyOYpes2P0vN6bcnGdXkAb8iL94sOO/C1Y69VxvVx
         vajY41u48cTSZ7KEabtxmmlbBLJO4jU/Ap574=
Message-ID: <19f34abd0807102223s207800b3gc3ac97fb3fb0a222@mail.gmail.com>
Date: Fri, 11 Jul 2008 07:23:15 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: v2.6.26-rc9: kernel BUG at kernel/sched.c:5858!
Cc: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Christoph Lameter" <clameter@sgi.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>, miaox@cn.fujitsu.com,
       "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Avi Kivity" <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200807102220.47068.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710115954.GA3639@damson.getinternet.no>
	 <19f34abd0807100716k35e937batb4059f99fe46731b@mail.gmail.com>
	 <19f34abd0807101249y24632b50h769a7af2c9514864@mail.gmail.com>
	 <200807102220.47068.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 10:20 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> This looks like it has very much to do with CPU hotplug/unplug. Is
>> there a race between SLUB/hotplug since the CPU slab is used after it
>> has been freed?
>
> I wonder if this is related to the fix at:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=70ff05554f91a1edda1f11684da1dbde09e2feea

Hi,

I thought it might as well, but in fact it happened regardless of this patch.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
