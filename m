Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbYEGBld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbYEGBld (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbYEGBk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:40:56 -0400
Received: from relay2.sgi.com ([192.48.171.30]:45219 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755312AbYEGBky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:40:54 -0400
Date: Tue, 6 May 2008 20:40:54 -0500
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: menage@google.com, seto.hidetoshi@jp.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix cpuset sched_relax_domain_level control file
Message-Id: <20080506204054.564fff32.pj@sgi.com>
In-Reply-To: <20080506183138.546f42d9.akpm@linux-foundation.org>
References: <48210101.1070205@google.com>
	<20080506183138.546f42d9.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew wrote:
> There is a patch in linux-next called "cpuset: system sets" which will
> conflict with your change.

Yeah - I was looking at that patch earlier today, when I was
scratching my head, trying to figure out what I broke with
mmotm.

I still don't like it.  The conversation evolved into a couple of
positions, mine and someone elses, I forget whom.  From what I
can recall now, neither of those positions endorsed the original
patch, as you have it.  Then the conversation died out, as all
parties involved other than perhaps myself prefer to work on stuff
that can result in successful patches, rather than ongoing debates.

What's the easiest way to get from where we are now, to a world
without that patch?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
