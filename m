Return-Path: <linux-kernel-owner+w=401wt.eu-S1761702AbYJJPFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761702AbYJJPFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 11:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757858AbYJJPFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 11:05:24 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51086 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756540AbYJJPFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 11:05:23 -0400
Date: Fri, 10 Oct 2008 17:04:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hans Schou <linux@schou.dk>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] More informative about unknown CPU
Message-ID: <20081010150458.GG11695@elte.hu>
References: <Pine.LNX.4.64.0810092014190.7473@sko.w0.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810092014190.7473@sko.w0.dk>
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


* Hans Schou <linux@schou.dk> wrote:

> Hi
>
> Write the name of the unknown vendor_id to output instead of just 
> "file not found".
>
> Tag changed to 'vendor_id' as used in /proc/cpuinfo
>
> Signed-off-by: Hans Schou <linux@schou.dk>

applied to tip/x86/unify-cpu-detect, thanks Hans!

> --- linux.trees.git/arch/x86/kernel/cpu/common.c.orig   2008-10-09 17:33:29.000000000 +0200
> +++ linux.trees.git/arch/x86/kernel/cpu/common.c        2008-10-09 17:33:59.000000000 +0200
> @@ -413,7 +413,7 @@ static void __cpuinit get_cpu_vendor(str
>
>         if (!printed) {
>                 printed++;
> -               printk(KERN_ERR "CPU: Vendor unknown, using generic init.\n");
> +               printk(KERN_ERR "CPU: vendor_id '%s' unknown, using generic init.\n", v);
>                 printk(KERN_ERR "CPU: Your system may be unstable.\n");

btw., this was whitespace damaged (i fixed that up by hand). See 
Documentation/email-clients.txt about how to set up the email client. 
(or, when you send x86 patches, you can attach the patch as a MIME 
attachment)

	Ingo
