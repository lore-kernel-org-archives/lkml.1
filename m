Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbYHNXSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbYHNXSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 19:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbYHNXSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 19:18:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:35775 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbYHNXSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 19:18:21 -0400
Date: Thu, 14 Aug 2008 15:25:22 -0700
From: Greg KH <greg@kroah.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: Core kernel parameters and /sys/parameters?
Message-ID: <20080814222522.GO30057@kroah.com>
References: <200807311359.02561.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807311359.02561.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 01:59:02PM +1000, Rusty Russell wrote:
> Hi Greg,
> 
>    Was looking at implementing "core_param" for things like "initcall_debug"
> (ie. params with no prefix), and wanted to put them in sysfs of course.  I
> hacked in a new "kernel" dir, but /sys/module/kernel/parameters/ is a bit
> of an odd place for it to end up in.
> 
>    I noticed this comment in params.c:
> 
>  * /sys/module/[mod->name]/parameters to /sys/parameters/[mod->name]/
> 
> I like the idea of /sys/parameters/ much better (perhaps even with core
> parameters at the top level).  Is this obsolete?  Planned?

Did I write that comment?  I sure don't remember it, sorry :)

I don't have any plans on changing this, but I do know people use the
/sys/module/MODULE_NAME/parameters interface today, why change it?

thanks,

greg k-h
