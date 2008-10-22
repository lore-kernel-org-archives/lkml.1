Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbYJVGTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbYJVGTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 02:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbYJVGS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 02:18:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36903 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbYJVGS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 02:18:56 -0400
Date: Wed, 22 Oct 2008 08:18:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: roel kluin <roel.kluin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Make static
Message-ID: <20081022061845.GB651@elte.hu>
References: <48FE6A75.5080004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FE6A75.5080004@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* roel kluin <roel.kluin@gmail.com> wrote:

> Make static
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>
> Building an allnoconfig, sparse asked whether these could be static, 
> so I checked, and they are only used in the file where they are 
> declared. This means that they can be static, am I forgetting 
> something? This was build and checkpatch tested.

yeah, it's correct!

>  arch/x86/boot/video-bios.c |    4 ++--
>  arch/x86/boot/video-vesa.c |    4 ++--
>  arch/x86/kernel/xsave.c    |    2 +-

i've applied these bits to tip/x86/urgent,

>  kernel/irq/proc.c          |    2 +-

this bit to tip/irq/urgent,

>  kernel/printk.c            |    2 +-

and this bit to tip/core/urgent.

Thanks Roel,

	Ingo
