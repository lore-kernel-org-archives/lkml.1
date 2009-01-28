Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbZA1F2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbZA1F2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 00:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbZA1F22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 00:28:28 -0500
Received: from ns.suse.de ([195.135.220.2]:60571 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbZA1F21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 00:28:27 -0500
Date: Tue, 27 Jan 2009 21:26:30 -0800
From: Greg KH <gregkh@suse.de>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
Message-ID: <20090128052630.GA9512@suse.de>
References: <1232704065.25510.1296328851@webmail.messagingengine.com> <20090123170631.GB11566@suse.de> <20090124130334.GA8031@brong.net> <20090125110126.GA11598@brong.net> <20090125122039.GA16603@brong.net> <20090128003519.GA11395@suse.de> <20090128033824.GA1662@brong.net> <alpine.DEB.1.10.0901271942270.20262@alien.or.mcafeemobile.com> <20090128035746.GA3351@brong.net> <alpine.DEB.1.10.0901272002180.20262@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901272002180.20262@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 08:10:41PM -0800, Davide Libenzi wrote:
> In my servers, I know if they are going to be loaded, and I bump NFILES 
> (and a few other things) to the correct place. Since many of those 
> limits do not actually pre-allocate any resource, I don't need to wait and 
> monitor the values, before taking proper action.

But what about people who want to know what the current usages are, so
that they _can_ monitor things and adjust them on the fly if things are
about to go boom?

I see no reason why we can't leave the value where it is today, and add
the ability to both turn the limits off entirely, and also report our
current usage.  That keeps the DOS from happening on "default" systems,
and lets admins have an idea if they need to bump up the values on their
systems as well.

I don't understand your objection to allowing the usage to be monitored.

confused,

greg k-h
