Return-Path: <linux-kernel-owner+w=401wt.eu-S1757974AbYAPAlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbYAPAlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 19:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYAPAl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 19:41:29 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:42782 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbYAPAl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 19:41:28 -0500
Date: Tue, 15 Jan 2008 19:40:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Frank Rowand <frank.rowand@am.sony.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH 1/4] RT: remove duplicate time/Kconfig
Message-ID: <20080116004051.GF30532@goodmis.org>
References: <1200435525.4092.14.camel@bx740>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200435525.4092.14.camel@bx740>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 02:18:45PM -0800, Frank Rowand wrote:
> 
> Index: linux-2.6.24-rc7/arch/mips/Kconfig
> ===================================================================
> --- linux-2.6.24-rc7.orig/arch/mips/Kconfig
> +++ linux-2.6.24-rc7/arch/mips/Kconfig
> @@ -1775,8 +1775,6 @@ config NR_CPUS
>  	  performance should round up your number of processors to the next
>  	  power of two.
>  
> -source "kernel/time/Kconfig"
> -

This doesn't apply with -rt2. Are you sure you have the right tree?

-- Steve

>  #
>  # Timer Interrupt Frequency Configuration
