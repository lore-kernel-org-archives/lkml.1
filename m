Return-Path: <linux-kernel-owner+w=401wt.eu-S1752317Ab0ATIUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab0ATIUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 03:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288Ab0ATIUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 03:20:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:34202 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab0ATIUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 03:20:18 -0500
Message-ID: <4B56BDBB.9060200@kernel.org>
Date: Wed, 20 Jan 2010 17:24:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 32/40] async: introduce workqueue based alternative implementation
References: <1263776272-382-1-git-send-email-tj@kernel.org>	<1263776272-382-33-git-send-email-tj@kernel.org>	<20100117220130.214d56f1@linux.intel.com>	<4B5420A3.3080200@kernel.org>	<20100118072523.2683cd59@linux.intel.com>	<4B55038D.3070106@kernel.org>	<4B550384.8030103@linux.intel.com>	<4B5565BE.4050406@kernel.org>	<20100119063718.3f1f39cc@linux.intel.com>	<4B564C23.1030708@kernel.org>	<4B564ECC.9080707@linux.intel.com>	<4B566590.5030804@kernel.org> <20100119220303.6767a553@linux.intel.com>
In-Reply-To: <20100119220303.6767a553@linux.intel.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Jan 2010 08:18:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/20/2010 03:03 PM, Arjan van de Ven wrote:
>> Yeap, but then again, whatever we do, all those synchronization
>> interfaces can be mapped onto each other eventually.

Eh... gave it a shot and it was too complex.

> and maybe we need to be smart about this;
> for me, sharing the backend implementation (the pool part) makes sense,
> although a thread pool really is not much code. But a smart thread pool
> may be.
>
> as for interfaces, I really really think it's ok to have different
> interfaces for usecases that are very different, as long as the
> interfaces are logical in their domain. I rather have 2 interfaces, each
> logical to their domain, than a forced joined interface that doesn't
> really naturally fit either.

I'll just replace the backend worker pool for now.  If necessary, we
can try to unify the sync model later, I suppose.

Thanks.

-- 
tejun
