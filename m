Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbYAVL0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbYAVL0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 06:26:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750817AbYAVL0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 06:26:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54865 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbYAVL03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 06:26:29 -0500
Date: Tue, 22 Jan 2008 12:26:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 1/3] x86: make printk_address available on X86_32
Message-ID: <20080122112608.GD26634@elte.hu>
References: <1200956275.16972.39.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200956275.16972.39.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Small fomatting fixes to 64-bit as well, trailing whitespace and extra 
> semicolon, also move the ifdefs for CONFIG_KALLSYMS into the function 
> itself.

thanks, applied. Could you send a followup fix for:

> +	char namebuf[128];

that should be KSYM_NAME_LEN.

>  	char namebuf[128];

ditto.

	Ingo
