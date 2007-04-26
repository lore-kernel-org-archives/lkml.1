Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbXDZVdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbXDZVdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755138AbXDZVdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:33:19 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:34647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024AbXDZVdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:33:19 -0400
Date: Thu, 26 Apr 2007 14:33:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Timur Tabi <timur@freescale.com>
Cc: Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       Kumar Gala <galak@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: 2.6.21-rc7-mm2
Message-Id: <20070426143304.c445427b.akpm@linux-foundation.org>
In-Reply-To: <46311231.3090903@freescale.com>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
	<46309142.2010907@googlemail.com>
	<20070426133720.25085207.akpm@linux-foundation.org>
	<46311231.3090903@freescale.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 15:57:21 -0500 Timur Tabi <timur@freescale.com> wrote:

> Andrew Morton wrote:
> 
> >> drivers/net/Kconfig:2327:warning: 'select' used by config symbol 
> >> 'UCC_GETH' refer to undefined symbol 'UCC_FAST'
> > 
> > Yes, we get so many of those that I tend to ignore them, assuming that
> > someone will pick it up and fix it.
> 
> Is this being compiled on a non-ppc/powerpc platform?

yup, sorry I forgot to mention that: i386 `make allmodconfig'.

