Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbZKOILd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbZKOILd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 03:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbZKOILd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 03:11:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60161 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZKOILc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 03:11:32 -0500
Date: Sun, 15 Nov 2009 09:11:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Am??rico Wang <xiyou.wangcong@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sysctl.c: Change a .proc_handler = proc_dointvec to
 &proc_dointvec,
Message-ID: <20091115081126.GD15432@elte.hu>
References: <1258249925.16857.198.camel@Joe-Laptop.home>
 <20091115065958.GA2459@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091115065958.GA2459@hack>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Am??rico Wang <xiyou.wangcong@gmail.com> wrote:

> On Sat, Nov 14, 2009 at 05:52:05PM -0800, Joe Perches wrote:
> >Seems to be a typo.
> >
> 
> Well, in this case, proc_dointvec == &proc_dointvec,
> both of them are the same function pointer.
> 
> But yes, &proc_dointvec looks more readable.
> 
> >Signed-off-by: Joe Perches <joe@perches.com>
> 
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

(Cc:-ed Eric who is running the sysctl tree these days)

Almost everywhere in the kernel we use the shorter version, so all of 
sysctl.c should eventually change to that variant.

	Ingo
