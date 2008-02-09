Return-Path: <linux-kernel-owner+w=401wt.eu-S1756927AbYBIVYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927AbYBIVYe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 16:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbYBIVYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 16:24:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58496 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756669AbYBIVYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 16:24:21 -0500
Date: Sat, 9 Feb 2008 22:24:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Avi Kivity <avi@argo.co.il>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] make KVM selectable again
Message-ID: <20080209212401.GA13888@elte.hu>
References: <1202590755.14165.11.camel@nimitz.home.sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202590755.14165.11.camel@nimitz.home.sr71.net>
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


* Dave Hansen <haveblue@us.ibm.com> wrote:

>  config HAVE_SETUP_PER_CPU_AREA
>  	def_bool X86_64
>  
> -select HAVE_KVM
> +config HAVE_KVM
> +	def_bool y

i think it might be better to just move the select to after the "config 
X86" option. (this is a legitimate use of select) Sam, do you concur?

(but, your current fix should go in ASAP, so no objections from me.)

	Ingo
