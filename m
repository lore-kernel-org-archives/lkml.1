Return-Path: <linux-kernel-owner+w=401wt.eu-S933004AbXEGLTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbXEGLTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 07:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXEGLTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 07:19:51 -0400
Received: from za-gw.sanpeople.com ([196.211.225.226]:2944 "EHLO
	za-gw.sanpeople.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933004AbXEGLTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 07:19:51 -0400
X-Greylist: delayed 1325 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 May 2007 07:19:49 EDT
Subject: Re: [PATCH 1/2] Use common cpu_is_xxx() macros on AT91 and AVR32
From: Andrew Victor <andrew@sanpeople.com>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: akpm@linux-foundation.org, David Brownell <david-b@pacbell.net>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <11785276841920-git-send-email-hskinnemoen@atmel.com>
References: <11785276841920-git-send-email-hskinnemoen@atmel.com>
Content-Type: text/plain
Organization: Multenet Technologies (Pty) Ltd
Message-Id: <1178534593.27286.28.camel@fuzzie.sanpeople.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.2.2 
Date: 07 May 2007 12:43:13 +0200
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Several drivers shared between AT91 and AVR32 chips use cpu_is_xxx()
> to handle CPU-specific differences. Currently, such code needs to be
> inside #ifdef CONFIG_ARCH_AT91 because the macros don't exist on AVR32.
> 
> By defining the same macros on both AT91 and AVR32, these #ifdefs can
> be eliminated. Since the macros will evaluate to a constant value for
> CPUs that aren't supported by the current architecture, any code that
> is only needed on AT91 will be optimized away on AVR32 and vice versa.
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>

Acked-by: Andrew Victor <andrew@sanpeople.com>



