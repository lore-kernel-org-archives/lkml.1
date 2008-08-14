Return-Path: <linux-kernel-owner+w=401wt.eu-S1753743AbYHNXdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743AbYHNXdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 19:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYHNXc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 19:32:56 -0400
Received: from ozlabs.org ([203.10.76.45]:40977 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbYHNXc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 19:32:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <greg@kroah.com>
Subject: Re: Core kernel parameters and /sys/parameters?
Date: Fri, 15 Aug 2008 09:32:43 +1000
User-Agent: KMail/1.9.9
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org
References: <200807311359.02561.rusty@rustcorp.com.au> <20080814222522.GO30057@kroah.com>
In-Reply-To: <20080814222522.GO30057@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808150932.44204.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 August 2008 08:25:22 Greg KH wrote:
> On Thu, Jul 31, 2008 at 01:59:02PM +1000, Rusty Russell wrote:
> > Hi Greg,
> >
> >    Was looking at implementing "core_param" for things like
> > "initcall_debug" (ie. params with no prefix), and wanted to put them in
> > sysfs of course.  I hacked in a new "kernel" dir, but
> > /sys/module/kernel/parameters/ is a bit of an odd place for it to end up
> > in.
> >
> >    I noticed this comment in params.c:
> >
> >  * /sys/module/[mod->name]/parameters to /sys/parameters/[mod->name]/
> >
> > I like the idea of /sys/parameters/ much better (perhaps even with core
> > parameters at the top level).  Is this obsolete?  Planned?
>
> Did I write that comment?  I sure don't remember it, sorry :)
>
> I don't have any plans on changing this, but I do know people use the
> /sys/module/MODULE_NAME/parameters interface today, why change it?

Well mainly that many of them aren't modules, so if a change was planned for 
some other reason I'd support it.

And as I said, having core parameters (ie. converting things which are current 
__setup) appear in /sys/module/kernel/parameters/ is a bit strange.

Cheers,
Rusty.
