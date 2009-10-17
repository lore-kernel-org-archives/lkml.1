Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbZJQUqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbZJQUqk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 16:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZJQUqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 16:46:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60261 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbZJQUqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 16:46:39 -0400
Date: Sat, 17 Oct 2009 13:46:08 -0700
From: Greg KH <gregkh@suse.de>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] fix driver_register() return value
Message-ID: <20091017204608.GA5676@suse.de>
References: <4ADA29AA.9070907@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADA29AA.9070907@aknet.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 18, 2009 at 12:31:38AM +0400, Stas Sergeev wrote:
> Hi Greg.
>
> In this patch:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=16dc42e018c2868211b4928f20a957c0c216126c
> the check was added for another
> driver to already claim the same
> device on the same bus. But the
> returned error code was wrong:
> to modprobe, the -EEXIST means
> that _this_ driver is already
> installed. It therefore doesn't
> produce the needed error message
> when _another_ driver is trying
> to register for the same device.
> Returning -EBUSY fixes the problem.
>
> Signed-off-by: Stas Sergeev <stsp@aknet.ru>

Does this cause problems with the way things now are?  If so, what are
they?  Does this change need to be backported to older -stable kernels?

thanks,

greg k-h
