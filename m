Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0CIXmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 18:42:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33906 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323Ab0CIXme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 18:42:34 -0500
Date: Tue, 9 Mar 2010 15:41:52 -0800
From: Greg KH <gregkh@suse.de>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, devel <devel@driverdev.osuosl.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: Tuxradar patching article and [PATCH]
 scripts/cvt_kernel_style.pl
Message-ID: <20100309234152.GA30270@suse.de>
References: <1268177526.1545.62.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268177526.1545.62.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 03:32:06PM -0800, Joe Perches wrote:
> There was an article published recently:
> http://www.tuxradar.com/content/newbies-guide-hacking-linux-kernel
> that seems to have prompted several new contributors (welcome)
> to create style reformatting patches.
> 
> The article recommends running checkpatch and fixing the various
> non-conforming style elements the output produces.
> 
> A better solution might be to enhance checkpatch to rewrite the
> patch or a file with -f, but that's more than I'd like to do.

I _really_ dislike automatic source conversions by a tool and do not
recommend doing that at all.

It's better that you look at the code yourself, and make the change that
looks correct, which is not always the same thing that an automated tool
would do.

Becides, we have the Lindent script, which does almost exactly what you
are trying to do here, why reinvent the wheel?

thanks,

greg k-h
