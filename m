Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbYHGMwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbYHGMwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbYHGMtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:49:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37394 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166AbYHGMtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:49:51 -0400
Date: Thu, 7 Aug 2008 11:28:00 +0200
From: Pavel Machek <pavel@suse.cz>
To: tvrtko.ursulin@sophos.com
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, malware-list@lists.printk.net,
       Rik van Riel <riel@redhat.com>
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linuxinterfaceforon access scanning
Message-ID: <20080807092800.GA22222@atrey.karlin.mff.cuni.cz>
References: <20080806064418.6afa0672@infradead.org> <20080806141656.8B44B2FE94A@pmx1.sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806141656.8B44B2FE94A@pmx1.sophos.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Problems with inotify as far as I know:
> 
> You can't do something like inotify("/") (made up API) but you have to set 
> up a watch for every directory you wan't to watch. That seems like a waste 
> of resources.
> 
> Then you get back a file name, if you wan't to report it or attempt* to 
> scan it you have to build a pathname yourself, which means you have to 
> maintain the whole tree of names in memory. Even bigger waste.
> 
> When I say attempt to scan it above I mean that we are back into the 
> pathanme teritorry. It is not guaranteed we will be able to open and scan 
> using that pathname. I don't know what inotify reports with chroots and 
> private namespaces, but it can certainly fail with NFS and root_squash. So 
> it is less effective as well as being resource intensive.
> 
> I think this is a good amount of flaws which shows inotify isn't really 
> ideal.

Not ideal, but looks like good enough, and could certainly be
improved. If it is secure-enough for you (I think it is), that looks
like a way to go.

(Plus, such improvements would actually be very welcome).
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
