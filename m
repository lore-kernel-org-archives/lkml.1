Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbZA1Aji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbZA1Aji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 19:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbZA1Aj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 19:39:29 -0500
Received: from cantor.suse.de ([195.135.220.2]:55059 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbZA1Aj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 19:39:29 -0500
Date: Tue, 27 Jan 2009 16:35:19 -0800
From: Greg KH <gregkh@suse.de>
To: Bron Gondwana <brong@fastmail.fm>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>
Subject: Re: [patch 016/104] epoll: introduce resource usage limits
Message-ID: <20090128003519.GA11395@suse.de>
References: <20081203193901.715896543@mini.kroah.org> <20081203194849.GQ8950@kroah.com> <1232686261.9977.1296303473@webmail.messagingengine.com> <20090123051620.GA8122@suse.de> <1232704065.25510.1296328851@webmail.messagingengine.com> <20090123170631.GB11566@suse.de> <20090124130334.GA8031@brong.net> <20090125110126.GA11598@brong.net> <20090125122039.GA16603@brong.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090125122039.GA16603@brong.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2009 at 11:20:39PM +1100, Bron Gondwana wrote:
> On Sun, Jan 25, 2009 at 10:01:27PM +1100, Bron Gondwana wrote:
> > On Sun, Jan 25, 2009 at 12:03:34AM +1100, Bron Gondwana wrote:
> > > The attached patches do this - the first bumps the default to 1024, and
> > > the second adds /proc/sys/fs/epoll/limits which contains 4 values.  The
> > > first two are the maximum current value for each field, and the second
> > > two are the values of max_user_instances and max_user_watches again,
> > > similar to the file-max interface.
> > 
> > And this third one (on top of the other two) adds the UIDs of the most
> > heavily using users to the "limits" file, to help you track them down.
> 
> Patch 4 - I'll stop now ;)

Heh.

Can you resubmit all 4 patches, and cc: the epoll author, Davide?  He's
the one that needs to accept these changes.

thanks,

greg k-h
