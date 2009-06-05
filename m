Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbZFEF5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbZFEF5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 01:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbZFEF5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 01:57:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:38488 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbZFEF5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 01:57:47 -0400
Message-ID: <4A28B3A9.3010505@kernel.org>
Date: Thu, 04 Jun 2009 22:56:57 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpumask: alloc blank cpumask left over
References: <4A2835D8.6040903@kernel.org> <4A28362B.7040804@kernel.org> <200906051428.08299.rusty@rustcorp.com.au>
In-Reply-To: <200906051428.08299.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Fri, 5 Jun 2009 06:31:31 am Yinghai Lu wrote:
>> avoid suprise when MAXSMP is enabled
>>
>> Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>
> 
> I understand the temptation, but two questions arise:
> 1) Shouldn't we actually audit to see if any of these are currently problems, 
those are defined as static cpumask_var_t, and if MAXSMP is not used, they are cleared already

> and
> 2) Should the non-MAXSMP alloc_cpumask_var_node (currently a noop) zero the 
> mask if __GFP_ZERO is set?

No. in that case, should cpumask_clear instead.

YH
