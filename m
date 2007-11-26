Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbXKZSKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbXKZSKo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 13:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXKZSKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 13:10:37 -0500
Received: from [198.99.130.12] ([198.99.130.12]:57971 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbXKZSKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 13:10:37 -0500
Date: Mon, 26 Nov 2007 13:10:23 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: uml doesn't work on 2.6.24-rc2
Message-ID: <20071126181023.GA10280@c2.user-mode-linux.org>
References: <E1Is5FL-00078H-00@dorka.pomaz.szeredi.hu> <20071114011002.GA11477@c2.user-mode-linux.org> <E1IsFbA-0007y2-00@dorka.pomaz.szeredi.hu> <20071114142247.GA5848@c2.user-mode-linux.org> <E1IsK83-0008CJ-00@dorka.pomaz.szeredi.hu> <20071114173639.GA7899@c2.user-mode-linux.org> <E1IsPo5-0008RU-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IsPo5-0008RU-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 10:29:57PM +0100, Miklos Szeredi wrote:
> nanosleep({0, 0}, {0, 0})               = 0
> gettimeofday({1195075504, 182333}, NULL) = 0
> setitimer(ITIMER_VIRTUAL, {it_interval={0, 0}, it_value={0, 0}}, {it_interval={0, 0}, it_value={0, 0}}) = 0
> nanosleep({0, 0}, {0, 0})               = 0

nevermind - I had accidentally done a defconfig and turned NO_HZ back
on.  With you config put back, I can reproduce this again.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
