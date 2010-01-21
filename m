Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475Ab0AUXLK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab0AUXLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 18:11:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347Ab0AUXLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 18:11:06 -0500
Received: from kroah.org ([198.145.64.141]:60838 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab0AUXLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 18:11:01 -0500
Date: Thu, 21 Jan 2010 15:03:31 -0800
From: Greg KH <greg@kroah.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: tty tree build warning
Message-ID: <20100121230331.GA29796@kroah.com>
References: <20100120171901.b2e06465.sfr@canb.auug.org.au>
 <b9df5fa11001202022q22c2d81cs5b90f694be37c1f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9df5fa11001202022q22c2d81cs5b90f694be37c1f4@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 10:22:19AM +0600, Rakib Mullick wrote:
> On 1/20/10, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi Greg,
> >
> >  Today's linux-next build (x86_64 allmodconfig) produced this warning:
> >
> >  drivers/char/ip2/ip2main.c:511: warning: 'ip2_setup' defined but not used
> >
> Can we use module parameters? A check could be made if parameter hasn't
> passed then we'll just return.

That sounds right.  Care to send a patch?

thanks,

greg k-h
