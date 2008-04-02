Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbYDBKkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbYDBKkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 06:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYDBKjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 06:39:53 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33204 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752880AbYDBKjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 06:39:52 -0400
Date: Wed, 2 Apr 2008 05:39:49 -0500
From: Paul Jackson <pj@sgi.com>
To: Mike Travis <travis@sgi.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: add cpuset_scnprintf function
Message-Id: <20080402053949.8f71b31d.pj@sgi.com>
In-Reply-To: <47F33A1D.3050301@sgi.com>
References: <20080401225422.064890000@polaris-admin.engr.sgi.com>
	<20080402012006.1722c2bd.pj@sgi.com>
	<47F33A1D.3050301@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike wrote:
> I wanted to not break current apps unmercifully, but perhaps I should
> default it to the "non-compatible" mode (and adjust the schedstat version
> to indicate this)?  [It's the only output that I found that seemed to care.]

It doesn't matter which way you set the default.  My concerns apply
either way.  I don't think your reply addressed my concerns.


> I know if I'm a user and I'm really interested in understanding
> the outputs when there's hundreds and hundreds of cpus, then the
> more compact format is much more useful.

That's not sufficient reason to change an API visible across the
kernel-user boundary.


> Plus I was under the impression that one of the basic tenets of Linux
> was that API's can and will change?

Kernel internals have a relatively lower barrier to API changes.

Kernel API's visible to kernel drivers or loadable modules have a
higher barrier to change.

Kernel API's visible to user space, such as this one, have a much
higher barrier to incompatible change.

I hesitate to NAQ patches because I strike out more often than someone
like Al Viro.  But I'm getting tempted on this one.

Perhaps you could write yourself a user utility that scanned its input
for masks in legacy format, converted them to list format, and passed
all else unscathed?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
