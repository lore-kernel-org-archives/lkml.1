Return-Path: <linux-kernel-owner+w=401wt.eu-S965492AbXA3J5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965492AbXA3J5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 04:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965497AbXA3J5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 04:57:40 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53256 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965492AbXA3J5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 04:57:39 -0500
Date: Tue, 30 Jan 2007 12:56:59 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Andrew Morton <akpm@osdl.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-ID: <20070130095659.GE2455@2ka.mipt.ru>
References: <20070129204528.eb8d695e.akpm@osdl.org> <45BECEAB.4090201@garzik.org> <20070129211139.8d584d89.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070129211139.8d584d89.akpm@osdl.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Tue, 30 Jan 2007 12:57:00 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 09:11:39PM -0800, Andrew Morton (akpm@osdl.org) wrote:
> > Now that kevent work has settled down, would you be open to including it 
> > in -mm?
> > 
> 
> I just haven't had the bandwidth to track what's been happening there
> lately.  The two main things which need to be done are
> 
> -  a detailed line-by-line review
> 
> - for someone to gain a full understanding of the delta between <these
>   patches> and <ulrich> and to explain these differences to mortals and to
>   convince themselves and the rest of us that we're all OK.

This requires either mind-reading machine, or some feedback from Ulrich.
Last main from him about kevent was related to 25 release.

As far as I can see, only questionable parts are signal mask in
syscalls, but nature of kevent signal delivering does not require it,
since mask of pending signals is not updated if special flag is set,
and exceeded functionality (like hrtimers accessible through kevent
interface and as POSIX addon).

-- 
	Evgeniy Polyakov
