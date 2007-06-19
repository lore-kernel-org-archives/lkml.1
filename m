Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbXFSIFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbXFSIFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 04:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbXFSIEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 04:04:54 -0400
Received: from twin.jikos.cz ([213.151.79.26]:58633 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbXFSIEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 04:04:53 -0400
Date: Tue, 19 Jun 2007 10:04:40 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Roman Zippel <zippel@linux-m68k.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Quota netlink interface
In-Reply-To: <20070619081120.GC18638@duck.suse.cz>
Message-ID: <Pine.LNX.4.64.0706191002150.3068@twin.jikos.cz>
References: <20070618121455.GI9319@duck.suse.cz> <20070618120103.2807b78d.randy.dunlap@oracle.com>
 <20070619081120.GC18638@duck.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Jan Kara wrote:

>   OK, I can make it 'depends on NET' instead. I guess it's no problem in
> this case since whoever wants quota is going to have NET enabled.
>   The problem I sometimes have with 'depends on' is that the option is
> invisible until you have enabled all the dependencies so it's hard to
>   a) find out that there exists and interesting feature (because it depends
> on something you are not used to turn on).
>   b) you know the feature exists but you have to dig in Kconfigs to find out
> what you have to enable first...
>   Maybe we could improve Kconfig to support other type of dependency that
> shows you the option even if these dependencies are not satisfied (probably in
> some other color) but allows you to only view help and unresolved
> dependencies...

(added Roman to CC)

I'd really appreciate this feature for precisely the same reasons indeed. 
Roman, what do you think about it?

Thanks,

-- 
Jiri Kosina
