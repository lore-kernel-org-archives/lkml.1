Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbYAESfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbYAESfS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 13:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbYAESfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 13:35:05 -0500
Received: from mga06.intel.com ([134.134.136.21]:57203 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756206AbYAESfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 13:35:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,249,1196668800"; 
   d="scan'208";a="249555057"
Message-ID: <477FCD63.1000101@linux.intel.com>
Date: Sat, 05 Jan 2008 10:33:07 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: mpm@selenic.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org
Subject: Re: [patch 1/3] move WARN_ON() out of line
References: <E1JAysR-0000Hn-00@gondolin.me.apana.org.au>
In-Reply-To: <E1JAysR-0000Hn-00@gondolin.me.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> Arjan van de Ven <arjan@linux.intel.com> wrote:
>>> While we're here, I'll mention that dump_stack probably ought to take a
>>> severity level argument.
>> 125 files changed, 202 insertions(+), 199 deletions(-)
>> just to get the api change done.
>> I can hear akpm cringe from here...
> 
> You don't have to change all of them at once. 

Having 2 is just silly though, and it'll take a long time, if ever,
to do this sort of thing slowly. Better to do it all at once.
The amount of change doesn't get smaller if you spread it out;
it's still a question if the total amount of change is worth
the added functionality.

