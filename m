Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbYDGTJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbYDGTJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 15:09:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbYDGTJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 15:09:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39937 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbYDGTJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 15:09:15 -0400
Date: Mon, 7 Apr 2008 21:09:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: bootmem allocator
Message-ID: <20080407190904.GH12292@elte.hu>
References: <20080407185613.GD9211@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080407185613.GD9211@cvg>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Hi Ingo, Peter,
> 
> small question. It was a patch recently posted which removes memset(x, 
> 0, x) after __alloc_bootmem call. There are a few another code 
> snippets who still call memset(x, 0, x). And who is responsible for 
> memory clearing? bootmem allocator or caller?

hm, bootmem allocator is supposed to clear memory. We have a couple of 
places that rely on that.

	Ingo
