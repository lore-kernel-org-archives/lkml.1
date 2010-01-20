Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210Ab0ATAbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab0ATAbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 19:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120Ab0ATAbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 19:31:11 -0500
Received: from mga05.intel.com ([192.55.52.89]:24224 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751460Ab0ATAbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 19:31:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,306,1262592000"; 
   d="scan'208";a="532706038"
Message-ID: <4B564ECC.9080707@linux.intel.com>
Date: Tue, 19 Jan 2010 16:31:08 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 32/40] async: introduce workqueue based alternative implementation
References: <1263776272-382-1-git-send-email-tj@kernel.org>	<1263776272-382-33-git-send-email-tj@kernel.org>	<20100117220130.214d56f1@linux.intel.com>	<4B5420A3.3080200@kernel.org>	<20100118072523.2683cd59@linux.intel.com>	<4B55038D.3070106@kernel.org>	<4B550384.8030103@linux.intel.com>	<4B5565BE.4050406@kernel.org> <20100119063718.3f1f39cc@linux.intel.com> <4B564C23.1030708@kernel.org>
In-Reply-To: <4B564C23.1030708@kernel.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/19/2010 16:19, Tejun Heo wrote:

> Yeah, you can flush individual works from other works and wqs from
> works running from different wqs.  What's not allowed is flushing the
> wq a work is running on from the work.  Let's say if the flush code
> can be modified to do so, would that change your opinion?

once you get "run in parallel, but have an API to wait on everyone who was scheduled before me"...
... that'd be fine ;)

but then you pretty much HAVE the cookie API, even if you don't have an actual cookie.
(just the cookie was an easy way to determine the "before me")
