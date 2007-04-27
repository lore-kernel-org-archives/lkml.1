Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbXD0B6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbXD0B6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 21:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbXD0B6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 21:58:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:60927 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383AbXD0B6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 21:58:16 -0400
From: Neil Brown <neilb@suse.de>
To: Ulrich Drepper <drepper@redhat.com>
Date: Fri, 27 Apr 2007 11:57:56 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17969.22692.855242.359680@notabene.brown>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utimensat implementation
In-Reply-To: message from Ulrich Drepper on Thursday April 26
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday April 26, drepper@redhat.com wrote:
> The next revision of POSIX will support fine-grained filesystem
> timestamps the way we already support.  struct stat will report
> nanosecond values.  So far so good.  

Does it also specify how to find out what granularity is used by the
filesystem?  I had a need for this just recently and couldn't see any
way to extract it.

[If the mtime of a file matches the current time, then you cannot
cache the contents of the file.  You have to wait until the mtime is
in the past.  Without knowing the granularity, you cannot tell if the
mtime still matches current time or not]

Thanks,
NeilBrown
