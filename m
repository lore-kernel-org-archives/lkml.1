Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbXI1STT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbXI1STT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbXI1STM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:19:12 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:38245 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbXI1STL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:19:11 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 28 Sep 2007 11:19:04 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: F_DUPFD_CLOEXEC implementation
In-Reply-To: <200709281734.l8SHYTmd027235@devserv.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.0709281113390.22521@alien.or.mcafeemobile.com>
References: <200709281734.l8SHYTmd027235@devserv.devel.redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007, Ulrich Drepper wrote:

> One more small change to extend the availability of creation of
> file descriptors with FD_CLOEXEC set.  Adding a new command to
> fcntl() requires no new system call and the overall impact on
> code size if minimal.
> 
> If this patch gets accepted we will also add this change to the
> next revision of the POSIX spec.
> 
> To test the patch, use the following little program.  Adjust the
> value of F_DUPFD_CLOEXEC appropriately.

I think new system calls would have been a cleaner way to accomplish this. 
The "small pill at a time" may have better chance to go in, but will 
likely result in an uglier userspace interface.
In any case, this is better than *nothing*, if it makes it easier to use 
fds inside system libraries.



- Davide


