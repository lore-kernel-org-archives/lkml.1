Return-Path: <linux-kernel-owner+w=401wt.eu-S1758951AbYB0Vvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951AbYB0Vvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 16:51:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYB0Vvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 16:51:36 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:25875 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbYB0Vvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 16:51:35 -0500
Date: Wed, 27 Feb 2008 13:49:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.24.3
Message-Id: <20080227134945.c1430710.randy.dunlap@oracle.com>
In-Reply-To: <20080226041545.GA30567@suse.de>
References: <20080226010024.GA26889@suse.de>
	<20080225195229.11ec1f12.randy.dunlap@oracle.com>
	<20080226041545.GA30567@suse.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 20:15:45 -0800 Greg KH wrote:

> On Mon, Feb 25, 2008 at 07:52:29PM -0800, Randy Dunlap wrote:
> > On Mon, 25 Feb 2008 17:00:24 -0800 Greg Kroah-Hartman wrote:
> > 
> > > We (the -stable team) are announcing the release of the 2.6.24.3
> > > kernel.
> > > 
> > > It fixes a number of different bugs and all users of the 2.6.24 series
> > > are encouraged to upgrade.
> > > 
> > > I'll also be replying to this message with a copy of the patch between
> > > 2.6.24.2 and 2.6.24.3
> > > 
> > > The updated 2.6.24.y git tree can be found at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.24.y.git
> > > and can be browsed at the normal kernel.org git web browser:
> > >         http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.24.y.git;a=summary
> > 
> > When HEADERS_CHECK=y:
> > 
> > make[3]: *** No rule to make target `/local/linsrc/linux-2.6.24.3/include/linux/if_addrlabel.h', needed by `/local/linsrc/linux-2.6.24.3/usr/include/linux/if_addrlabel.h'.  Stop.
> > make[2]: *** [linux] Error 2
> 
> Is this a regression from 2.6.24.2?

Yes.

> If so, any ideas which patch caused it?

No, but I thought that we had already been thru this...

---
~Randy
