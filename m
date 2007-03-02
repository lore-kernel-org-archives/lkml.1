Return-Path: <linux-kernel-owner+w=401wt.eu-S965063AbXCBJgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965063AbXCBJgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 04:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965191AbXCBJgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 04:36:06 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59463 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965063AbXCBJgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 04:36:03 -0500
Date: Fri, 2 Mar 2007 10:35:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>, Robin Holt <holt@sgi.com>,
       David Howells <dhowells@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, Hideo AOKI <haoki@redhat.com>
Subject: Re: [PATCH 4/4] coredump: documentation for proc entry
Message-ID: <20070302093543.GB2001@elf.ucw.cz>
References: <45E7AAFA.4070402@hitachi.com> <45E7AD6B.1090102@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E7AD6B.1090102@hitachi.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +If you don't want to dump all shared memory segments attached to pid 1234,
> +write 0 to the process's proc file.
> +
> +  $ echo 1 > /proc/1234/coredump_omit_anonymous_shared

Write 0?

> +When a new process is created, the process inherits the flag status from its
> +parent. It is useful to set the flag before the program runs.
> +For example:
> +
> +  $ echo 1 > /proc/self/coredump_omit_anonymous_shared
> +  $ ./some_program
> +

Notice that this docs is wrong. You have to retry until kernel stops
producing spurious errors.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
