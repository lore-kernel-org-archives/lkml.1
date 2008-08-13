Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbYHMOSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbYHMOSB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 10:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbYHMOQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 10:16:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55900 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756764AbYHMOQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 10:16:43 -0400
Date: Wed, 13 Aug 2008 16:16:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, David Miller <davem@davemloft.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Message-ID: <20080813141629.GD19397@elte.hu>
References: <Pine.LNX.4.64.0808061908100.12476@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808061908100.12476@boston.corp.fedex.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Chua <jeff.chua.linux@gmail.com> wrote:

> On Wed, Aug 6, 2008 at 5:42 PM, Jeff Chua <jeff.chua.linux@gmail.com>  
> wrote:
>>>> CONFIG_X86_GENERICARCH=y
>>>> CONFIG_X86_BIGSMP=y
>>>> 8 more cpu need bigsmp mode.
>
>> Just found it under " Subarchitecture Type (Generic architecture)",
>> and then it shows the CONFIG_X86_BIGSMP option.
>
> It works. Booted with 16CPUs. 32GB RAM.

btw., could you please check that v2.6.27-rc3 (or later) kernels boot 
fine (with about 8 cpus) even if you hae genericarch/bigsmp disabled, 
and do not silently hang as it happened on your box before?

	Ingo
