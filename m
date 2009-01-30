Return-Path: <linux-kernel-owner+w=401wt.eu-S1753186AbZA3GYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbZA3GYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 01:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZA3GYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 01:24:12 -0500
Received: from mail.gmx.net ([213.165.64.20]:55227 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751346AbZA3GYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 01:24:11 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+X1F9Khw6XOLgRLhKsbBNge0Vk7Jpt78S9LxYAIx
	JVJ9UhFdSGYQ0X
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
	scheduling
From: Mike Galbraith <efault@gmx.de>
To: Nathanael Hoyle <nhoyle@hoyletech.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1233294584.28741.2.camel@localhost>
References: <1233294584.28741.2.camel@localhost>
Content-Type: text/plain
Date: Fri, 30 Jan 2009 07:24:07 +0100
Message-Id: <1233296647.6071.15.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-30 at 00:49 -0500, Nathanael Hoyle wrote:

> Recently I installed the Folding@Home client, which many of you may be
> familiar with, intended to utilize spare CPU cycles to perform protein
> folding simulations in order to further medical research.  It is not a
> multi-threaded client at this point, so it simply runs four instances on
> my system, since it has four cores.  It is configured to run at
> nice-level 19.
> 
> Because it is heavily optimized, and needs little external data to
> perform its work, it spends almost all of its time cpu-bound, with
> little to no io-wait or blocking on network calls, etc.  I had been
> using it for about a week with no real difficulty until I went to watch
> another DVD and found that the video was slightly stuttery/jerky so long
> as foldingathome was running in the background.  Once I shut it down,
> the video playback resumed its normal smooth form.

Sounds like a problem was recently fixed.  Can you try 2.6.29-rc3 or
2.6.28.2?

	-Mike

