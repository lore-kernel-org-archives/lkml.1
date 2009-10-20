Return-Path: <linux-kernel-owner+w=401wt.eu-S932479AbZJTA4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479AbZJTA4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 20:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932441AbZJTA4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 20:56:33 -0400
Received: from ozlabs.org ([203.10.76.45]:36413 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932448AbZJTA4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 20:56:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Carmelo Amoroso <carmelo73@gmail.com>
Subject: Re: Fast LKM symbol resolution with SysV ELH hash table
Date: Tue, 20 Oct 2009 11:26:25 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: Greg KH <greg@kroah.com>, Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-kbuild" <linux-kbuild@vger.kernel.org>
References: <4ADACD3A.9020803@gmail.com> <20091019132205.GA7192@kroah.com> <2ccd6e3c0910190802w117f8ac1nb562214786904c04@mail.gmail.com>
In-Reply-To: <2ccd6e3c0910190802w117f8ac1nb562214786904c04@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910201126.26110.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Oct 2009 01:32:51 am Carmelo Amoroso wrote:
> 2009/10/19 Greg KH <greg@kroah.com>:
> > On Mon, Oct 19, 2009 at 01:45:20PM +0200, Carmelo Amoroso wrote:
> >> Just a few other notes. The current implementation I did based on SysV
> >> has a drawback that is not backward compatible, so you cannot use old
> >> modules with a kernel with the option enabled due to changes on struct
> >> kernel_symbol.
> >
> > Why would this be a problem?  Whenever making a kernel config change,
> > you should be able to rebuild everything, as lots of other configuration
> > options are that way.
> 
> This is not always true... there could be cases in which you cannot
> recompile old modules
> (e.g vendors that provide non GPL modules)

And breaking them is a feature.  I do not go out of my way to avoid breaking
out-of-tree modules; it's certainly more important to have simple maintainable
code.

You guys figure out what the best speed/size tradeoff is, and send me the
patch for review.

Thanks!
Rusty.
