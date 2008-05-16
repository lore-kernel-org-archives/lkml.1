Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbYEPNCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbYEPNCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 09:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYEPNCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 09:02:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55782 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbYEPNCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 09:02:38 -0400
Date: Fri, 16 May 2008 09:02:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Siewior <bigeasy@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, Greg Ungerer <gerg@uclinux.org>,
       uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: add FTRACE support
Message-ID: <20080516130237.GB8100@goodmis.org>
References: <1210697565-3106-1-git-send-email-bigeasy@linutronix.de> <1210697565-3106-2-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210697565-3106-2-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 06:52:43PM +0200, Sebastian Siewior wrote:
>  
>  config DYNAMIC_FTRACE
>  	bool "enable/disable ftrace tracepoints dynamically"
> -	depends on FTRACE
> +	depends on FTRACE && !COLDFIRE

I think we really need to add a HAVE_DYNAMIC_FTRACE config for archs to
say that this is supported. Otherwise I imagine that we'll have a list
of archs here.

I'll write up a patch today.

-- Steve



>  	default y
>  	help
>           This option will modify all the calls to ftrace dynamically
