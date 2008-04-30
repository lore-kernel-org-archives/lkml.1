Return-Path: <linux-kernel-owner+w=401wt.eu-S933897AbYD3WHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbYD3WHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762670AbYD3WD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:03:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51861 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765370AbYD3WD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:03:56 -0400
Date: Wed, 30 Apr 2008 15:03:15 -0700
From: Greg KH <greg@kroah.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-git16 fails with "undefined reference to
	`compat_mc_getsockopt'"
Message-ID: <20080430220315.GA11136@kroah.com>
References: <20080430204622.GA1663@kroah.com> <20080430.144906.105396672.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430.144906.105396672.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 02:49:06PM -0700, David Miller wrote:
> From: Greg KH <greg@kroah.com>
> Date: Wed, 30 Apr 2008 13:46:22 -0700
> 
> > Don't know if you have seen this or not, but 2.6.25-gi16 seems to fail
> > with:
> > 	net/built-in.o: In function `ipv6_getsockopt':
> > 	(.text+0x6829c): undefined reference to `compat_mc_getsockopt'
> > 
> > I've attached my .config below if that helps any.
> 
> Known problem and there is a fix pending, sit tight.

Great, thanks for letting me know and sending the patch to Linus, I
appreciate it.

greg k-h
