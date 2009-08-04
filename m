Return-Path: <linux-kernel-owner+w=401wt.eu-S933065AbZHDV1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065AbZHDV1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 17:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933041AbZHDV1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 17:27:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:42968 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932598AbZHDV1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 17:27:50 -0400
Date: Tue, 4 Aug 2009 14:25:38 -0700
From: Greg KH <gregkh@suse.de>
To: Joe Peterson <joe@skyrush.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] n_tty: honor opost flag for echoes
Message-ID: <20090804212538.GA26478@suse.de>
References: <4A789AA1.5070907@skyrush.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A789AA1.5070907@skyrush.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 04, 2009 at 02:31:29PM -0600, Joe Peterson wrote:

> Fixes the following bug:
> 
>       http://bugs.linuxbase.org/show_bug.cgi?id=2692
> 
> Causes processing of echoed characters (output from the echo buffer) to
> honor the O_OPOST flag.  This re-establishes this behavior.
> 
> Note that this and the next patch ("n_tty: move echoctl check and
> clean up logic") were verified together by the bug reporters, and
> all tty tests now pass.

What "tty tests" would that be?  Have a pointer to them?

thanks,

greg k-h
