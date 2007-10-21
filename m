Return-Path: <linux-kernel-owner+w=401wt.eu-S1751675AbXJUCrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675AbXJUCrT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 22:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbXJUCrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 22:47:12 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:54664 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750831AbXJUCrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 22:47:11 -0400
Date: Sat, 20 Oct 2007 19:46:56 -0700
From: Paul Jackson <pj@sgi.com>
To: Milton Miller <miltonm@bga.com>
Cc: mingo@elte.hu, akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix sched_domain sysctl registration again
Message-Id: <20071020194656.96c6ff86.pj@sgi.com>
In-Reply-To: <200710201948.l9KJml5L008962@sullivan.realtime.net>
References: <200710201948.l9KJml5L008962@sullivan.realtime.net>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for catching these, Milton.

I had done my testing against 2.6.23-rc8-mm2 and earlier, so had not
picked up your earlier debug sysctl patches from Oct 12 or so that
first fixed this, so had not noticed that the resulting merge of your
work and mine was borked.

... somedays even the latest *-mm just isn't good enough.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
