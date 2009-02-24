Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbZBXAvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbZBXAvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZBXAv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:51:29 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:1044 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbZBXAv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:51:28 -0500
Message-ID: <49A343EE.20100@phoenixsoftware.de>
Date: Tue, 24 Feb 2009 01:48:46 +0100
From: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6.28.7] BUG: using smp_processor_id() in preemptible [00000000]
 code: pageattr-test/207
References: <49A2ECF5.80104@phoenixsoftware.de> <20090223151331.033e0bf5.akpm@linux-foundation.org>
In-Reply-To: <20090223151331.033e0bf5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Score: -0.395 () AWL,BAYES_50,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009 15:13:31 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> A 2.6.28.6 -> 2.6.28.7 regressionlet.
> 
> This, I bet:
> 
> commit 2cf155b300c4839a7238b825c7c5f417e9d7cc68
> Author: Jeremy Fitzhardinge <jeremy@goop.org>
> Date:   Wed Feb 11 09:32:19 2009 -0800
> 
>     x86/cpa: make sure cpa is safe to call in lazy mmu mode
>     
>     commit 4f06b0436b2ddbd3b67b10e77098a6862787b3eb upstream.

Jackpot! Reverted that commit on 2.6.28.7, and the BUG messages are gone.

Thanks,
Tilman
