Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbZDVWza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbZDVWza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 18:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbZDVWzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 18:55:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41578 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751126AbZDVWzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 18:55:16 -0400
Date: Wed, 22 Apr 2009 23:53:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, mark.langsdorf@amd.com, arekm@maven.pl,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [patch 2/2] x86 amd fix cmpxchg read acquire barrier
Message-ID: <20090422235358.0e0cc7f3@lxorguk.ukuu.org.uk>
In-Reply-To: <20090422224749.GA22718@Krystal>
References: <20090422201852.092307236@polymtl.ca>
	<20090422202453.829846363@polymtl.ca>
	<20090422215913.67c1298e@lxorguk.ukuu.org.uk>
	<20090422224749.GA22718@Krystal>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Good point. I should probably configure this as "nothing" unless
> 
> #ifdef CONFIG_X86_64
> #if (defined(CONFIG_GENERIC_CPU) || defined(CONFIG_MK8))
> ...
> #endif
> #endif

Is the erratum only present in 64bit mode ?

Really this needs someone with knowledge of the erratum to characterise
it accurately and the workarounds.
