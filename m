Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbZFEE6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbZFEE6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 00:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbZFEE6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 00:58:11 -0400
Received: from ozlabs.org ([203.10.76.45]:40599 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbZFEE6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 00:58:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] cpumask: alloc blank cpumask left over
Date: Fri, 5 Jun 2009 14:28:07 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4A2835D8.6040903@kernel.org> <4A28362B.7040804@kernel.org>
In-Reply-To: <4A28362B.7040804@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906051428.08299.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009 06:31:31 am Yinghai Lu wrote:
> avoid suprise when MAXSMP is enabled
>
> Signed-off-by: Yinghai Lu <yinghai.lu@kernel.org>

I understand the temptation, but two questions arise:
1) Shouldn't we actually audit to see if any of these are currently problems, 
and
2) Should the non-MAXSMP alloc_cpumask_var_node (currently a noop) zero the 
mask if __GFP_ZERO is set?

Thanks,
Rusty.
