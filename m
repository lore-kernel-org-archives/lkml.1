Return-Path: <linux-kernel-owner+w=401wt.eu-S1757332AbYAVU5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbYAVU5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbYAVU4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:56:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42714 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347AbYAVU4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:56:46 -0500
Date: Tue, 22 Jan 2008 21:56:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       tglx@linutronix.de
Subject: Re: [PATCH] x86: constify function pointer tables
Message-ID: <20080122205636.GF12892@elte.hu>
References: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de> <Pine.LNX.4.64.0801222051140.5722@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801222051140.5722@fbirervta.pbzchgretzou.qr>
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


* Jan Engelhardt <jengelh@computergmbh.de> wrote:

> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

thanks, applied.

btw., please send future x86 cleanup patches against x86.git#mm. For 
example, this bit:

> -struct seq_operations cpuinfo_op = {
> +const struct seq_operations cpuinfo_op = {
>  	.start =c_start,

already looks a bit different there so it didnt apply straight away. (i 
fixed that up so no need to resend)

x86.git#mm tracking coordinates are at:

    http://redhat.com/~mingo/x86.git/README

	Ingo
