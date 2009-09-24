Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbZIXAFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbZIXAFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 20:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbZIXAFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 20:05:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbZIXAFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 20:05:06 -0400
Message-ID: <4ABAB81D.4050703@redhat.com>
Date: Wed, 23 Sep 2009 17:06:53 -0700
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL] tracing/kprobes: Kprobes core/tracing/profiling	updates
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com> <20090923105252.GA32176@elte.hu> <20090923212438.GA5190@nowhere> <20090923214642.GA30061@elte.hu> <20090923221356.GA23390@elte.hu>
In-Reply-To: <20090923221356.GA23390@elte.hu>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> got this post-test failure with the new kprobes bits:
> 
>  make[2]: `scripts/unifdef' is up to date.
>    TEST    posttest
>  Error: c145cf71:        f3 0f a6 d0             repz xsha256 
>  Error: objdump says 4 bytes, but insn_get_length() says 3 (attr:0)
>  make[1]: *** [posttest] Error 2
>  make: *** [bzImage] Error 2
> 
> Config attached.
> 
> GNU objdump version 2.18.50.0.6-7.fc9 20080403
> gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) 

Oh, Thank you for reporting!
I'll update instruction maps.

Thank you again!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

