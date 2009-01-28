Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbZA1Ezp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbZA1Ezp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 23:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZA1Ezh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 23:55:37 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:38584 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752486AbZA1Ezg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 23:55:36 -0500
Date: Wed, 28 Jan 2009 15:55:34 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ray Lee <ray-lk@madrabbit.org>, Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] epoll: increase default max_user_instances to 1024
Message-ID: <20090128045534.GA7571@brong.net>
References: <20090128033824.GA1662@brong.net> <59410684d947bc68862a4f5d6c2a5bb1f29519ee.1233114169.git.brong@fastmail.fm> <alpine.DEB.1.10.0901271949070.20262@alien.or.mcafeemobile.com> <2c0942db0901272007w4298738cq37918f776276d424@mail.gmail.com> <alpine.DEB.1.10.0901272010470.20262@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901272010470.20262@alien.or.mcafeemobile.com>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 08:14:36PM -0800, Davide Libenzi wrote:
> On Tue, 27 Jan 2009, Ray Lee wrote:
> > Userspace is not broken here, and the whole idea of a -stable series
> > is that administrators can upgrade to them without having to worry
> > about things getting broken or making specific configuration changes
> > by point release.
> 
> The reason Greg took it, was that in a multiuser systems, that's a DoS 
> EZ-PZ Lemon Squeezie.

Ok - we're at an impasse here.

You know the code a whole lot better than me.

Is there anything you can think of that will allow us to block the DOS
without breaking every medium to heavily loaded postfix and apache site
out there.

Somthing that doesn't require the administrators of every single
machine in one or the other class to tune their configurations?

Brong ( we expect you to know how to tune epoll, we don't expect every 
        apache and postfix administrator to know to tune a brand new 
        setting that just appeared in the last point release - especially 
        since most of them probably have no idea how many epoll watches
        their software creates as a single user, and have never needed 
        to think about it before)
