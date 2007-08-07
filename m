Return-Path: <linux-kernel-owner+w=401wt.eu-S937628AbXHGVit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937628AbXHGVit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936902AbXHGVNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 17:13:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:45810 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S936896AbXHGVNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 17:13:22 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX189T557Dxc9AyjDjYn7TE7liXivksJeH1yj7Wh1YM
	gEXAcwLT9tYxGb
Message-ID: <46B8E05C.8080405@gmx.net>
Date: Tue, 07 Aug 2007 23:13:00 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ollie Wild <aaw@google.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: execve manpage changes
References: <65dd6fd50708061738pabd807tb26d38641cc5e7e2@mail.gmail.com> <65dd6fd50708061746p2a460fe5p24f1068c36ef5c40@mail.gmail.com>
In-Reply-To: <65dd6fd50708061746p2a460fe5p24f1068c36ef5c40@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ollie Wild wrote:
> Michael,
> 
> Per our previous discussion, here are the updates to the execve(2)
> manpage resulting from the variable length argument support patch in
> linux-2.6.23-rc1.  The execve API is unmodified.  However, the
> following should be noted in the "Notes" section.
> 
> Prior to linux-2.6.23, the memory used to store the environment and
> argument list strings was limited to 32 (MAX_ARG_PAGES) pages.  On
> most architectures, the page size is 4kB, leading to a maximum size of
> 128kB.
> 
> In linux-2.6.23 and later, most architectures support a size limit
> derived from the current RLIMIT_STACK setting (see getrlimit(2)).  For
> these architectures, the total size is limited to 1/4 the allowed
> stack size, the limit per string is 32 pages (MAX_ARG_STRLEN), and the
> maximum number of strings is 0x7FFFFFFF.  Architectures with no memory
> management unit are excepted: they maintain the pre-2.6.23 limit.

Hello Ollie,

Thanks.  I'll see that this material makes it into a man pages release 
closer to the 2.6.23 final release.

Cheers,

Michael
