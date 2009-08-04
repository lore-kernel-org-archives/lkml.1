Return-Path: <linux-kernel-owner+w=401wt.eu-S933563AbZHDXQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563AbZHDXQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 19:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbZHDXQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 19:16:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40135 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753569AbZHDXQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 19:16:34 -0400
Date: Tue, 4 Aug 2009 16:16:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, rolandd@cisco.com
Subject: Re: mmotm 2009-08-04-14-22 uploaded (ummunotify)
Message-Id: <20090804161623.c920596a.akpm@linux-foundation.org>
In-Reply-To: <20090804155014.35d4597c.randy.dunlap@oracle.com>
References: <200908042125.n74LP9qY018119@imap1.linux-foundation.org>
	<20090804155014.35d4597c.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Aug 2009 15:50:14 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Tue, 04 Aug 2009 14:25:09 -0700 akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2009-08-04-14-22 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> > 
> > It contains the following patches against 2.6.31-rc5:
> 
> 
> Seems odd to me, but I'm seeing:
> 
> ummunotify.c:(.text+0x8f217): undefined reference to `__get_user_X'
> 
> when building for i386.
> 
> The get_user() and put_user() in ummunotify_exchange_features()
> are correctly converted to __get_user_4() and __put_user_4(),
> but the get_user() in ummunotify_unregister_region() becomes
> __get_user_X()  [as seen in objdump output].
> 
> toolchain issue or something else??
> 

yes, strange.

.config please?

Try `make drivers/char/ummunotify.i' then have a poke around in ummunotify.i?
