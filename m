Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbYLGF6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbYLGF6A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 00:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbYLGF52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 00:57:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46845 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbYLGF5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 00:57:24 -0500
Date: Sat, 6 Dec 2008 21:48:40 -0800
From: Greg KH <gregkh@suse.de>
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: [rfc] [patch] hook tracer to dynamic debug
Message-ID: <20081207054840.GA20541@suse.de>
References: <20081205193928.GA3134@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205193928.GA3134@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 02:39:28PM -0500, Jason Baron wrote:
> hi,
> 
> Currently, the dynamic debug framework uses 'printk' for output. Here,
> i've hooked the backend of the dynamic debug framework to the tracing 
> framework. This allows the dynamic debug output to be seaprated from the
> system log, and allows for higher performance.

Is this really an issue most of the time?

I know logs can get full, but this seems like a bit of an overkill :)

> I've implemented it as a compile time option, but a user might want to
> be able to toggle b/w 'printk' and the tracer at run-time...other
> ideas? Patch is against the -tip tree...

It would have to be a run-time option if you want any distro to ever be
able to enable this in their kernels.

thanks,

greg k-h
