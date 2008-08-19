Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbYHSVQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbYHSVQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751958AbYHSVP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:15:57 -0400
Received: from relay.2ka.mipt.ru ([194.85.80.65]:49900 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbYHSVP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:15:56 -0400
Date: Wed, 20 Aug 2008 01:15:14 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
Message-ID: <20080819211514.GA28510@2ka.mipt.ru>
References: <20080819.041706.261399060.davem@davemloft.net> <alpine.LFD.1.10.0808190952000.3324@nehalem.linux-foundation.org> <20080819.131454.223684377.davem@davemloft.net> <alpine.LFD.1.10.0808191341150.3324@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808191341150.3324@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 01:47:59PM -0700, Linus Torvalds (torvalds@linux-foundation.org) wrote:
> I really don't see the e1000 and netxen updates as being critical either. 
> Sure, they look like driver improvement, but "improvement" is not what the 
> -rc3+ series is about. 

Netxen driver update contains bug fixes (leak and races) and hardware
workaround. Well, it has driver version bump either, I agress, that
one was an error. E1000 contains number of regression fixes and
performance improvement via module parameter change.

> Same goes for all the loopback changes. They look like cleanups or feature 
> enables.

It fixes performance regression.

-- 
	Evgeniy Polyakov
