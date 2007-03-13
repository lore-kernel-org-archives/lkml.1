Return-Path: <linux-kernel-owner+w=401wt.eu-S965738AbXCMNuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965738AbXCMNuE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 09:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965740AbXCMNuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 09:50:04 -0400
Received: from colin.muc.de ([193.149.48.1]:1850 "EHLO mail.muc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965735AbXCMNuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 09:50:03 -0400
Date: 13 Mar 2007 14:50:00 +0100
Date: Tue, 13 Mar 2007 14:50:00 +0100
From: Andi Kleen <ak@muc.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Introduce load_TLS to the "for" loop.
Message-ID: <20070313135000.GA92373@muc.de>
References: <1173767976.10618.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173767976.10618.50.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 05:39:36PM +1100, Rusty Russell wrote:
> GCC (4.1 at least) unrolls it anyway, but I can't believe this code

Are you sure? Normally it doesn't unroll without -funroll-loops which
the kernel does normally not set. Especially not with -Os builds.

-Andi
