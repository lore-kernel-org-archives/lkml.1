Return-Path: <linux-kernel-owner+w=401wt.eu-S1761320AbYBAK4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320AbYBAK4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 05:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760757AbYBAK4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 05:56:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41780 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759766AbYBAK4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 05:56:38 -0500
Date: Fri, 1 Feb 2008 11:56:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: sparse errors from string_32.h
Message-ID: <20080201105624.GD27178@elte.hu>
References: <1201846516.23523.87.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201846516.23523.87.camel@brick>
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

>  		case 1:
> -			*(unsigned char *)s = pattern;
> +			*(unsigned char *)s = pattern & 0xff;

i've applied your fix - but wouldnt it be cleaner to just cast the 
pattern variable to unsigned char instead?

	Ingo
