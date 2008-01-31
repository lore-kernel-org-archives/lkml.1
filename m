Return-Path: <linux-kernel-owner+w=401wt.eu-S1765222AbYAaPAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765222AbYAaPAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757640AbYAaPAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:00:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34628 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757354AbYAaPAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:00:31 -0500
Date: Thu, 31 Jan 2008 16:00:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix small sparse warning
Message-ID: <20080131150016.GE27855@elte.hu>
References: <1201751530.23523.4.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201751530.23523.4.camel@brick>
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


* Harvey Harrison <harvey.harrison@gmail.com> wrote:

> arch/x86/kernel/ds.c:226:9: warning: Using plain integer as NULL 
> pointer

>  	kfree(*dsp);
> -	*dsp = 0;
> +	*dsp = NULL;

thanks, applied.

	Ingo
