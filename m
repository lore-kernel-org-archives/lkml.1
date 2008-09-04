Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbYIDXlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbYIDXlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 19:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbYIDXk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 19:40:59 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:56482 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYIDXk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 19:40:59 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=VwQbUJbxAAAA:8 a=IOxrLKaDUVcBsEV34hAA:9 a=n62vPFxoIj6YFC-ek_BnfkIbP3gA:4
Message-ID: <48C07203.1090706@shaw.ca>
Date: Thu, 04 Sep 2008 17:40:51 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: "Keith A. Prickett" <keithp@marvell.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: Building Kernel with -O0
References: <fa.NLANnOwj/8iuI5QjLt63gFrBDJA@ifi.uio.no>
In-Reply-To: <fa.NLANnOwj/8iuI5QjLt63gFrBDJA@ifi.uio.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keith A. Prickett wrote:
> I was looking at some changes to the 2.6.26.y kernel in "compiler-gcc.h"
> and had some questions.
> ( http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.26.y.git;a=commitdiff;h=ae3a0064e6d69068b1c9fd075095da062430bda9 )
> 
> I was attempting to cross-compile Linux for a Marvell core with
> Optimizations turned off and ran across an error due to the
> __attribute__((always_inline)) attribute.
> 
> It looks like the default behavior used to always have this feature on,
> but Ingo committed some changes that allows this behavior to be turned
> off (With the correct Kconfig file changes).
> 
> I'm VERY new to Linux but was wondering if there was a way (config
> option) to turn this inline attribute off in previous versions of the
> kernel besides these new macros.  It seems building with optimization
> level 0 should be a natural thing for kernel driver developers to do for
> debugging purposes.
> 
> In summary: I want to compile with optimizations off and the compile is
> failing now when I try this.  How can this be resolved?

I don't think this has ever been supported. Even in current kernels 
where the compiler is not always forced to inline all functions, I 
believe there are some functions that need to be inlined and still use 
forced inlining, and if no optimizations are enabled, no inlining can be 
done.
