Return-Path: <linux-kernel-owner+w=401wt.eu-S932407AbXAVT4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbXAVT4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbXAVT4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:56:45 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45504 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbXAVT4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:56:44 -0500
Date: Mon, 22 Jan 2007 11:56:38 -0800
From: Andrew Morton <akpm@osdl.org>
To: Nadia.Derbey@bull.net
Cc: linux-kernel@vger.kernel.org, Nadia.Derbey@bull.net
Subject: Re: [RFC][PATCH 6/6] automatic tuning applied to some kernel
 components
Message-Id: <20070122115638.835b26a1.akpm@osdl.org>
In-Reply-To: <20070116063030.761795000@bull.net>
References: <20070116061516.899460000@bull.net>
	<20070116063030.761795000@bull.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 16 Jan 2007 07:15:22 +0100 Nadia.Derbey@bull.net wrote:
> The following kernel components register a tunable structure and call the
> auto-tuning routine:
>   . file system
>   . shared memory (per namespace)
>   . semaphore (per namespace)
>   . message queues (per namespace)

This is the part of the patch series which really matters, and I just don't
understand it :(

Why do we want to autotune these things?  What problem is this patch series
solving?  Please describe this part of the work much, much more completely,
so we can understand the need to add such a large amount of code to the
kernel.

It seems strange that the whole feature is Kconfigurable.  Please also
explain the thinking behind that.

I suspect the patches would be much simpler if you simply required that all
these new tunables be of type `long'.  About seven eighths of the code
would go away.  As would most of those eye-popping macros.
