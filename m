Return-Path: <linux-kernel-owner+w=401wt.eu-S934731AbYBMWKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934731AbYBMWKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:10:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbYBMWJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:09:52 -0500
Received: from mx1.suse.de ([195.135.220.2]:43688 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbYBMWJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:09:51 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: print_vma_addr possible deadlock (was Re: Jeste jeden bug)
Date: Wed, 13 Feb 2008 23:09:43 +0100
User-Agent: KMail/1.9.6
Cc: Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, linux-kernel@vger.kernel.org
References: <c4e36d110802130841l591f20a4j32759821543b554c@mail.gmail.com> <Pine.LNX.4.64.0802131757360.7699@twin.jikos.cz> <20080213193538.GA16402@elte.hu>
In-Reply-To: <20080213193538.GA16402@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802132309.43184.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008 20:35:38 Ingo Molnar wrote:

> +	/*
> +	 * Do not print if we are in atomic
> +	 * contexts (in exception stacks, etc.):
> +	 */
> +	if (preempt_count())
> +		return;

It should print the address even in this case; just not resolve the VMA
name.

-Andi
