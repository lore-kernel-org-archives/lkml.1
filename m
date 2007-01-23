Return-Path: <linux-kernel-owner+w=401wt.eu-S932344AbXAWAAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344AbXAWAAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 19:00:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932393AbXAWAAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 19:00:35 -0500
Received: from outpost.ds9a.nl ([213.244.168.210]:35528 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932344AbXAWAAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 19:00:34 -0500
Date: Tue, 23 Jan 2007 01:00:30 +0100
From: bert hubert <bert.hubert@netherlabs.nl>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Paolo Ornati <ornati@fastwebnet.it>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org
Subject: Re: [PATCH] select: fix sys_select to not leak ERESTARTNOHAND to userspace
Message-ID: <20070123000030.GA7487@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Neil Horman <nhorman@tuxdriver.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Paolo Ornati <ornati@fastwebnet.it>, linux-kernel@vger.kernel.org,
	akpm@osdl.org, torvalds@osdl.org
References: <20070116201332.GA28523@hmsreliant.homelinux.net> <20070122145956.4a68762d@localhost> <20070122145259.GB21059@hmsreliant.homelinux.net> <Pine.LNX.4.64.0701220758120.32200@woody.linux-foundation.org> <20070122162406.GC21059@hmsreliant.homelinux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070122162406.GC21059@hmsreliant.homelinux.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 22, 2007 at 11:24:06AM -0500, Neil Horman wrote:

> The error was reported to me second hand.  I'm expecting a reproducer (although
> to date, I'm still waiting for it, so I may have jumped the gun here).  In fact,

I've asked for a repoducer weeks ago and nothing happened, nobody even
bothered to reply - I wrote a small test-app that might exhibit the problem,
but didn't manage to trigger it.

	Bert
	
-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
