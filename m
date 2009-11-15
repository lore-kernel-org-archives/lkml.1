Return-Path: <linux-kernel-owner+w=401wt.eu-S1752176AbZKOI2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbZKOI2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 03:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZKOI2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 03:28:30 -0500
Received: from mail.perches.com ([173.55.12.10]:1066 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbZKOI23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 03:28:29 -0500
Subject: Re: [PATCH] sysctl.c: Change a .proc_handler = proc_dointvec to
 &proc_dointvec,
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Am??rico Wang <xiyou.wangcong@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091115081126.GD15432@elte.hu>
References: <1258249925.16857.198.camel@Joe-Laptop.home>
	 <20091115065958.GA2459@hack>  <20091115081126.GD15432@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 Nov 2009 00:28:34 -0800
Message-ID: <1258273714.21668.13.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-11-15 at 09:11 +0100, Ingo Molnar wrote:
> * Am??rico Wang <xiyou.wangcong@gmail.com> wrote:
> > On Sat, Nov 14, 2009 at 05:52:05PM -0800, Joe Perches wrote:
> > >Seems to be a typo.
> > Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
> (Cc:-ed Eric who is running the sysctl tree these days)
> Almost everywhere in the kernel we use the shorter version, so all of 
> sysctl.c should eventually change to that variant.

It's closer to 50/50, but it's 1 vs 133 in that file.

$ grep -Pr --include=*.[ch] '\.proc_handler\s*=\s*&\s*\w+' * | wc -l
339

$ grep -Pr --include=*.[ch] '\.proc_handler\s*=\s*[^&]\s*\w+' * | wc -l
432


