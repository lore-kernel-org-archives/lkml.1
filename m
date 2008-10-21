Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbYJUNRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbYJUNRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 09:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYJUNQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 09:16:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47742 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbYJUNQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 09:16:58 -0400
Message-ID: <48FDD646.6070705@redhat.com>
Date: Tue, 21 Oct 2008 09:16:54 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Arch x86 is not supported with CONFIG_FTRACE_MCOUNT_RECORD
References: <20081021060945.GA14126@cs181140183.pp.htv.fi>
In-Reply-To: <20081021060945.GA14126@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Commit 8da3821ba5634497da63d58a69e24a97697c4a2b
> (ftrace: create __mcount_loc section) causes the
> following build error:
>
> <--  snip  -->
>
> $ make ARCH=x86
>   

Could you specify either i386 or x86_64 and see if that works. I may 
need to add a way to pass in subarchs to the script.

-- Steve

> ...
>   CC      scripts/mod/empty.o
> Arch x86 is not supported with CONFIG_FTRACE_MCOUNT_RECORD at /home/bunk/linux/kernel-2.6/git/linux-2.6/scripts/recordmcount.pl line 157.
> make[3]: *** [scripts/mod/empty.o] Error 255
>
> <--  snip  -->
>
> cu
> Adrian
>
>   

