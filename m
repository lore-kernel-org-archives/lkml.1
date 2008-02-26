Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbYB0Vkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbYB0Vkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYB0VkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:40:21 -0500
Received: from mx1.suse.de ([195.135.220.2]:44915 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbYB0VkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:40:21 -0500
Date: Mon, 25 Feb 2008 20:15:45 -0800
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.24.3
Message-ID: <20080226041545.GA30567@suse.de>
References: <20080226010024.GA26889@suse.de> <20080225195229.11ec1f12.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225195229.11ec1f12.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 07:52:29PM -0800, Randy Dunlap wrote:
> On Mon, 25 Feb 2008 17:00:24 -0800 Greg Kroah-Hartman wrote:
> 
> > We (the -stable team) are announcing the release of the 2.6.24.3
> > kernel.
> > 
> > It fixes a number of different bugs and all users of the 2.6.24 series
> > are encouraged to upgrade.
> > 
> > I'll also be replying to this message with a copy of the patch between
> > 2.6.24.2 and 2.6.24.3
> > 
> > The updated 2.6.24.y git tree can be found at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.24.y.git
> > and can be browsed at the normal kernel.org git web browser:
> >         http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=summary
> 
> When HEADERS_CHECK=y:
> 
> make[3]: *** No rule to make target `/local/linsrc/linux-2.6.24.3/include/linux/if_addrlabel.h', needed by `/local/linsrc/linux-2.6.24.3/usr/include/linux/if_addrlabel.h'.  Stop.
> make[2]: *** [linux] Error 2

Is this a regression from 2.6.24.2?  If so, any ideas which patch caused
it?

thanks,

greg k-h
