Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab0CJASK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 19:18:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34865 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565Ab0CJASG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 19:18:06 -0500
Date: Tue, 9 Mar 2010 16:16:38 -0800
From: Greg KH <gregkh@suse.de>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, devel <devel@driverdev.osuosl.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: Tuxradar patching article and [PATCH]
 scripts/cvt_kernel_style.pl
Message-ID: <20100310001638.GA10960@suse.de>
References: <1268177526.1545.62.camel@Joe-Laptop.home>
 <20100309234152.GA30270@suse.de>
 <1268179619.1545.95.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268179619.1545.95.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 04:06:59PM -0800, Joe Perches wrote:
> On Tue, 2010-03-09 at 15:41 -0800, Greg KH wrote:
> > On Tue, Mar 09, 2010 at 03:32:06PM -0800, Joe Perches wrote:
> > > There was an article published recently:
> > > http://www.tuxradar.com/content/newbies-guide-hacking-linux-kernel
> > > that seems to have prompted several new contributors (welcome)
> > > to create style reformatting patches.
> > > 
> > > The article recommends running checkpatch and fixing the various
> > > non-conforming style elements the output produces.
> > > 
> > > A better solution might be to enhance checkpatch to rewrite the
> > > patch or a file with -f, but that's more than I'd like to do.
> > 
> > I _really_ dislike automatic source conversions by a tool and do not
> > recommend doing that at all.
> 
> Don't be silly.
> 
> You take automatic conversions from tools like coccinelle all
> the time.

Those are sane, as they are tiny and obvious :)

It's the huge "reformat the whole file with indent" type stuff that I
object to.

> What I found poorly written about the article was
> unfortunately you apparently recommend things like:
> 
>         if (error != -ENODEV) {
>                 foo();
>                 bar();
>         } else {
>         	report_error();
>         	goto exit;
>         }
>         
> instead of:
> 
>         if (error == -ENODEV) {
>         	report_error();
>         	goto exit;
>         }
>         foo();
>         bar();

Hey, a job as a copyeditor awaits :)

> and the brace removal example was unfortunate because
> it used printk without KERN_<level> without explanation.
> 
> I think there wasn't enough emphasis on compiling the new
> patched file with something like a .o or .lst comparison
> to the unmodified source to make sure it was OK to send
> to the list.

One can only do so much in a few thousand words.  I'm sorry you disliked
the article, I know the magazine is always looking for new authors.

thanks,

greg k-h
