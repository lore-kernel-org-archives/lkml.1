Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbZDGFj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbZDGFj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 01:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZDGFjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 01:39:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:40790 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751721AbZDGFju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 01:39:50 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18gzMQu6YogfHR1msD+PQPGxR//T7G8ejusutc7Pf
	HZ9X24SeFjGcEC
Subject: Re: [2 regressions] Current git cannot find root device on x86-64
	(HP nx6325), NFS broken
From: Mike Galbraith <efault@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Tejun Heo <htejun@gmail.com>
In-Reply-To: <200904070047.56172.rjw@sisk.pl>
References: <200904070047.56172.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 07:39:44 +0200
Message-Id: <1239082784.5597.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 00:47 +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> Current mainline (commit 22ae77bc7ac115b9d518d5cbc13d39317079b2b0) can't
> find the root device (it's handled by statically compiled-in sata_sil) and
> generally causes the "invalid module format" message to appear for all modules
> loaded from the initrd on my HP nx6325 (the distro is openSUSE 11.1).
> 
> I don't know which commit might have made this happen, but the breakage was
> introduced during the last three days (commit
> 601cc11d054ae4b5e9b5babec3d8e4667a2cb9b5 is certainly good).  I'll bisect
> tomorrow if there are no ideas.

I bisected "invalid module format" woes to 9cb610d.

	-Mike

