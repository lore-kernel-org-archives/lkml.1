Return-Path: <linux-kernel-owner+w=401wt.eu-S965796AbXBTAsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965796AbXBTAsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965797AbXBTAsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:48:10 -0500
Received: from ns2.suse.de ([195.135.220.15]:46456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965796AbXBTAsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:48:08 -0500
Date: Mon, 19 Feb 2007 16:46:34 -0800
From: Greg KH <greg@kroah.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: Linux 2.6.16.41
Message-ID: <20070220004634.GA9922@kroah.com>
References: <20070218011406.GT13958@stusta.de> <20070219234846.GA5201@kroah.com> <20070220000110.GV13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220000110.GV13958@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 01:01:10AM +0100, Adrian Bunk wrote:
> On Mon, Feb 19, 2007 at 03:48:46PM -0800, Greg KH wrote:
> > On Sun, Feb 18, 2007 at 02:14:07AM +0100, Adrian Bunk wrote:
> > > Herbert Xu (1):
> > >       [NETFILTER]: Clear GSO bits for TCP reset packet
> > 
> > This patch causes the file it patched to not build at all.  Are you sure
> > it was correct to add this?
> 
> It compiled for me in my test builds.
> 
> Please send the .config and the error message.

Ugh, this was my fault.  It was a distro kernel error as they had
modified their tree in ways I wasn't expecting.

Nevermind, the mainline kernel builds just fine, sorry for the
disturbance.

thanks,

greg k-h
