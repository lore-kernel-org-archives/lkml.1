Return-Path: <linux-kernel-owner+w=401wt.eu-S1751336AbZL1Sn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbZL1Sn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 13:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbZL1Sn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 13:43:27 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33672 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbZL1Sn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 13:43:26 -0500
Message-ID: <4B38FC42.7000204@cs.helsinki.fi>
Date: Mon, 28 Dec 2009 20:43:14 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Nitin Gupta <ngupta@vflare.org>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] [mmotm] Add notifiers for various swap events
References: <1261963200-7136-1-git-send-email-ngupta@vflare.org> <87eimf87m5.fsf@basil.nowhere.org> <4B38D0CF.9000403@vflare.org> <20091228172903.GF4994@basil.fritz.box>
In-Reply-To: <20091228172903.GF4994@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Andi Kleen wrote:
>>> The first question to ask is if compressed swap is worth
>>> it. Do you have benchmark numbers showing it to be an improvement?
>>> Are there cases where it is slower than uncompressed swap?
>>>
>> http://code.google.com/p/compcache/wiki/Performance
> 
> That should be included in the changelog of the patches.

Which patches? The driver is already in staging and there's a pointer to 
the home page in

   linux/drivers/staging/ramzswap/ramzswap.txt

>> ramzswap is an optional module.
> 
> I have some doubts on the wisdom of making swap algorithms modular.
> Better compile them in. Then you don't need messy notifiers either.

What's so messy about them? The whole point of having the notifiers is 
to avoid CONFIG_RAMZSWAP in core kernel code...

			Pekka
