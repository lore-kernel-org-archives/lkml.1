Return-Path: <linux-kernel-owner+w=401wt.eu-S1756299AbYENGWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299AbYENGWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 02:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbYENGVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 02:21:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751453AbYENGVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 02:21:51 -0400
Date: Tue, 13 May 2008 23:21:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Norbert Preining <preining@logic.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.26-rc2 hosed X?
Message-Id: <20080513232139.812a36dd.akpm@linux-foundation.org>
In-Reply-To: <20080513103828.GA8288@gamma.logic.tuwien.ac.at>
References: <20080513103828.GA8288@gamma.logic.tuwien.ac.at>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008 12:38:28 +0200 Norbert Preining <preining@logic.at> wrote:

> Hi all,
> 
> I usually follow the -rc series with skipping the -rc1 (waiting for the
> worst errors to be fixed).
> 
> Here now a severe regression with respect to 2.6.25: X seems to be hosed
> in the sense that:
> - switching to console
> - suspend 2 ram
> - suspend 2 disk
> often leaves the computer completely unusable.
> 
> I am using:
> - Debian/sid up2date, i.e. xorg server 7.3
> - intel Chipset 945GM (Acer laptop)
> - intel xorg video driver 2.2.1 and 2.3.1 (both tested)
> 
> Since not even Sysrq is working I cannot get a log file or whatsoever.
> 
> Is that something known, are is there some patch to revert/test?
> 

I'm not aware of anything, no.

First thing to do is to test a more recent kernel, see if we already
fixed it.  Latest mainline would be good.  linux-next would be better. 
2.6.26-rc2-mm1 (hopefully a couple of hours away) would be best.

If we haven't fixed it then I'm afraid our best shot would be for you
to run a bisection (please). 
http://www.kernel.org/doc/local/git-quick.html


