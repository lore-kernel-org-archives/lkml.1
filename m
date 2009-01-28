Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbZA1Fib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbZA1Fib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 00:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZA1FiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 00:38:22 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37887 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750870AbZA1FiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 00:38:21 -0500
Date: Wed, 28 Jan 2009 16:38:19 +1100
From: Bron Gondwana <brong@fastmail.fm>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
       Bron Gondwana <brong@fastmail.fm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] epoll: increase default max_user_instances to 1024
Message-ID: <20090128053819.GA10556@brong.net>
References: <20090128033824.GA1662@brong.net> <59410684d947bc68862a4f5d6c2a5bb1f29519ee.1233114169.git.brong@fastmail.fm> <alpine.DEB.1.10.0901271949070.20262@alien.or.mcafeemobile.com> <2c0942db0901272007w4298738cq37918f776276d424@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0901272007w4298738cq37918f776276d424@mail.gmail.com>
Organization: brong.net
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 08:07:32PM -0800, Ray Lee wrote:
> On Tue, Jan 27, 2009 at 8:00 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> > $ echo NN > /proc/sys/fs/epoll/max_user_instances
> >
> > Note that NN does not consume any resource "per se", so if you feel
> > threatened by such limit, you can go wild with it.
> 
> It's really simple. A kernel upgrade in a -stable series point release
> broke a rational user-space setup. If you don't want to adjust the
> defaults, then the sane thing to do is to revert the commit that
> caused the grief. Postfix is everywhere. Apache is everywhere.
> 
> Userspace is not broken here, and the whole idea of a -stable series
> is that administrators can upgrade to them without having to worry
> about things getting broken or making specific configuration changes
> by point release.

Oh man - it's java too:

http://pero.blogs.aprilmayjune.org/

they also suggest 1024, independantly of everyone else by the looks of
things.

   "A day and several installation routines later we figured out that
    the available epoll resources were not sufficient any more. Java JDK 1.6
    uses epoll to implement non-blocking-IO. With kernel 2.6.27 resource
    limits have been introduced and the default on openSuSE is 128 - way too
    low."

How many more people's wasted days is it going to take to convince you
that it's broken as currently implemented?

Bron.
