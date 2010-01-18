Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379Ab0ARIpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab0ARIpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 03:45:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196Ab0ARIpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 03:45:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:41477 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755092Ab0ARIpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 03:45:07 -0500
Message-ID: <4B5420A3.3080200@kernel.org>
Date: Mon, 18 Jan 2010 17:49:39 +0900
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
References: <1263776272-382-1-git-send-email-tj@kernel.org>	<1263776272-382-33-git-send-email-tj@kernel.org> <20100117220130.214d56f1@linux.intel.com>
In-Reply-To: <20100117220130.214d56f1@linux.intel.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Jan 2010 08:43:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 03:01 PM, Arjan van de Ven wrote:
> I'm sorry but I'm really not happy with this conversion;
> it looses the very nice property of being able to execute and
> synchronize between places at the end just before device registration.

Hmm... can you elaborate a bit?

> I don't mind the implementation sharing thread pool with your stuff,
> but I really really want to keep the cookie and synchronization
> mechanism. There's a bunch of users of that pending and doing things
> sequential entirely just is not going to cut it.

For what async is currently used for, I don't think there will be any
noticeable difference.  If the proposed implementation is lacking
somewhere, we can definitely improve it although I'm not sure whether
it will end up with the cookie thing.

Thanks.

-- 
tejun
