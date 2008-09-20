Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbYITUPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbYITUPx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 16:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYITUPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 16:15:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54894 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYITUPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 16:15:45 -0400
Date: Sat, 20 Sep 2008 13:14:42 -0700
From: Greg KH <greg@kroah.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debug: Introduce a dev_WARN() function
Message-ID: <20080920201442.GA29622@kroah.com>
References: <20080919210733.4e9c58e8@infradead.org> <20080920042630.GA21501@kroah.com> <20080920111113.18954688@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080920111113.18954688@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 11:11:13AM -0700, Arjan van de Ven wrote:
> On Fri, 19 Sep 2008 21:26:30 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > On Fri, Sep 19, 2008 at 09:07:33PM -0700, Arjan van de Ven wrote:
> > > 
> > > From: Arjan van de Ven <arjan@linux.intel.com>
> > > Date: Fri, 19 Sep 2008 21:03:06 -0700
> > > Subject: [PATCH] debug: Introduce a dev_WARN() function
> > > 
> > > in the line of dev_printk(), this patch introduces a dev_WARN()
> > > macro, that takes a struct device and then a printk format/args set
> > > of arguments. Unlike dev_printk(), the effect is that of WARN() in
> > > that a full warning message (including filename/line, module list,
> > > versions and a backtrace) is printed in addition to the device name
> > > and the arguments.
> > 
> > I like the idea, but we already have dev_warn(), so dev_WARN() might
> > be a bit confusing for people.
> > 
> > Perhaps just documenting it with a docbook tag would suffice?
> > 
> 
> I added a set of comments, and also ended up doing the below USB change

Ok, that looks good, care to resend all of these, with the changed
original one so that I can apply them?

thanks,

greg k-h
