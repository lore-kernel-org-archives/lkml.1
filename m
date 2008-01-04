Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbYADTN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbYADTN7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 14:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYADTNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 14:13:50 -0500
Received: from relay2.sgi.com ([192.48.171.30]:56278 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751599AbYADTNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 14:13:50 -0500
Date: Fri, 4 Jan 2008 13:13:40 -0600
From: Paul Jackson <pj@sgi.com>
To: "rae l" <crquan@gmail.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       emdow@us.ibm.com
Subject: Re: [PATCH] PROC_FS: get and set the smp affinity of tasks by
 read-write /proc/<pid>/smp_affinity
Message-Id: <20080104131340.6e2a26b6.pj@sgi.com>
In-Reply-To: <91b13c310801040738h75465241wa1179d0e06131354@mail.gmail.com>
References: <1199430221-28417-1-git-send-email-crquan@gmail.com>
	<20080104015421.cc7a89f7.pj@sgi.com>
	<91b13c310801040738h75465241wa1179d0e06131354@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rael wrote:
> length check copied from kernel/irq/proc.c, now 'page' buffer couldn't
> be overrun,

Thanks.

> although Documentation/filesystems/proc.txt is heavily outdated,
> I'll add introduction of smp_affinity.

Good - my usual benchmark for documentation is that at least one place
in the code or associated documentation clearly describes things.

My main concern in this patch was that there were zero instances of
documentation of this new /proc file.  The patch should include a text
explanation of this feature, and put it somewhere.

Documentation/filesystems/proc.txt looked like a reasonable place, but
I don't really care where, nor do I lose as much sleep as I should when
some documentation is incomplete or stale.  Just so long as everything
is clearly explained somewhere.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
