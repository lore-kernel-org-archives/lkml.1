Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752207AbYLRHiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbYLRHiu (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 02:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbYLRHik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 02:38:40 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35307 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbYLRHik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 02:38:40 -0500
Date: Thu, 18 Dec 2008 08:38:25 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Cc: linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: time_is_after_jiffies misnomer
Message-ID: <20081218073824.GB2110@ucw.cz>
References: <200812161131.mBGBVfV17064@inv.it.uc3m.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812161131.mBGBVfV17064@inv.it.uc3m.es>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-12-16 12:31:41, Peter T. Breuer wrote:
> 
> I thought at first that
> 
>     time_is_after_jiffies(foo)
> 
> meant that the current time is later than foo jiffies. In fact, it's
> the reverse! (as far as I can tell! 2.6.26-11). 
> 
> Can we change this name or provide an alternative? Perhaps
> 
>    jiffies_is_later_than(foo)
> 
> ??

Yes, it is confusing and yes, it should be fixed. Probably by
introducing better names and switching callers to them.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
