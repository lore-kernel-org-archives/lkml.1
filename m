Return-Path: <linux-kernel-owner+w=401wt.eu-S1765057AbYCGEmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765057AbYCGEmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 23:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760534AbYCGEmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 23:42:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42588 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759056AbYCGEmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 23:42:09 -0500
Date: Thu, 6 Mar 2008 20:39:50 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for March 7
Message-ID: <20080307043950.GA669@kroah.com>
References: <20080307141856.b27d1725.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080307141856.b27d1725.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 02:18:56PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> (tar balls at
> http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).
> 
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log files
> in the Next directory.  Between each merge, the tree was built with
> allmodconfig for both powerpc and x86_64.
> 
> There were a few merge conflicts (trivial) and one build break.  I have
> notified the appropriate people.
> 
> We are up to 44 trees, more are welcome (even if they are currently
> empty).  The influx of new trees has been underwhelming.  Thanks to those
> who have contributed, and to those who haven't, please do.
> 
> Status of my local build tests is at
> http://kisskb.ellerman.id.au/kisskb/branch/9/.  If maintainers want to
> give advice about cross compilers/configs that work, we are always open
> to add more builds.  Build results from today on also include the actual
> compiler version string.
> 
> It looks like this one is going to build fail the same way as yesterday's tree:
> 
> drivers/usb/core/hub.c:633: error: 'struct usb_device' has no member named 'persist_enabled'
> drivers/usb/core/hub.c:719: error: 'struct usb_device' has no member named 'reset_resume'
> 
> for any config with CONFIG_PM disabled.

I have a patch in my to-apply queue for this, so hopefully it will not
happen tomorrow :)

thanks,

greg k-h
