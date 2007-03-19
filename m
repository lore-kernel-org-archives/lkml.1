Return-Path: <linux-kernel-owner+w=401wt.eu-S1030718AbXCSWGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030718AbXCSWGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 18:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030715AbXCSWGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 18:06:33 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:44374 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030718AbXCSWGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 18:06:32 -0400
Date: Mon, 19 Mar 2007 15:01:25 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Chris Wright <chrisw@sous-sol.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 03/31] Fix user copy length in ipv6_sockglue.c
Message-ID: <20070319220125.GD10574@sequoia.sous-sol.org>
References: <20070319213047.710101653@mini.kroah.org> <20070319213729.GE9261@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070319213729.GE9261@kroah.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (gregkh@suse.de) wrote:
> From: Chris Wright <chrisw@sous-sol.org>
> 
> [IPV6] fix ipv6_getsockopt_sticky copy_to_user leak
> 
> User supplied len < 0 can cause leak of kernel memory.
> Use unsigned compare instead.

You can drop this one.  It's dependent on a patch
that is not in 2.6.20.

thanks,
-chris
