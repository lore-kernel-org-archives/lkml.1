Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbYAYWke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbYAYWke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYAYWk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:40:27 -0500
Received: from ns2.suse.de ([195.135.220.15]:50647 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbYAYWk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:40:26 -0500
Date: Fri, 25 Jan 2008 14:38:58 -0800
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 183/196] driver core: fix build with SYSFS=n
Message-ID: <20080125223858.GA15723@suse.de>
References: <20080125071127.GA4860@kroah.com> <1201246425-5058-104-git-send-email-gregkh@suse.de> <20080125222530.GA23769@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125222530.GA23769@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 11:25:30PM +0100, Ingo Molnar wrote:
> 
> * Greg Kroah-Hartman <gregkh@suse.de> wrote:
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > When SYSFS=n and MODULES=y, build ends with:
> > 
> > linux-2.6.24-rc6-mm1/drivers/base/module.c: In function 'module_add_driver':
> > linux-2.6.24-rc6-mm1/drivers/base/module.c:49: error: 'module_kset' undeclared (first use in this function)
> > make[3]: *** [drivers/base/module.o] Error 1
> 
> _PLEASE_ fold such fixes into the patch that introduces the build bugs, 
> prior sending your git trees upstream! (just like Andrew does it with 
> all patches that come via -mm)

For most of these issues I do merge them together.

However, for some odd kernel configurations, like this one, I didn't, my
appologies.  I'll try to be more careful in the future.

> Changes like this (and it now leaked into Linus' tree as well) kill 
> bisectability.

The odds that a "normal" person has sysfs turned off and modules
enabled, trying to bisect things, is pretty slim :)

thanks,

greg k-h
