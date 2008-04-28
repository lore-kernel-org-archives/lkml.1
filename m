Return-Path: <linux-kernel-owner+w=401wt.eu-S938001AbYD1VUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938001AbYD1VUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935206AbYD1VUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:20:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38897 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934996AbYD1VUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:20:39 -0400
Date: Mon, 28 Apr 2008 23:20:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] dvb: build failure fix
Message-ID: <20080428212030.GA10912@elte.hu>
References: <20080428162421.GA16566@elte.hu> <20080428164730.43349c3d@gaivota> <20080428203056.GI15840@elte.hu> <20080428180327.7f6f5204@gaivota> <20080428211748.GJ15840@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428211748.GJ15840@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FYI, x86.git randconfig testing found another build bug as well:

  http://redhat.com/~mingo/misc/config-Mon_Apr_28_23_14_46_CEST_2008.bad

build log below. Note that this seems to be a more clear-cut case as 
module support was disabled.

	Ingo

--------------->
drivers/built-in.o: In function `cx23885_dvb_register':
: undefined reference to `dib7000p_attach'
drivers/built-in.o: In function `cx23885_initialize_codec':
cx23885-417.c:(.text+0x1dd5a7): undefined reference to `cx2341x_update'
drivers/built-in.o: In function `cx23885_queryctrl':
cx23885-417.c:(.text+0x1de02e): undefined reference to `cx2341x_ctrl_query'
drivers/built-in.o: In function `cx23885_417_register':
: undefined reference to `cx2341x_fill_defaults'
drivers/built-in.o: In function `mpeg_do_ioctl':
cx23885-417.c:(.text+0x1dea0e): undefined reference to `cx2341x_log_status'
cx23885-417.c:(.text+0x1dea67): undefined reference to `cx2341x_ctrl_get_menu'
cx23885-417.c:(.text+0x1dec1a): undefined reference to `cx2341x_ext_ctrls'
cx23885-417.c:(.text+0x1deeaf): undefined reference to `cx2341x_ext_ctrls'
cx23885-417.c:(.text+0x1deedb): undefined reference to `cx2341x_update'
drivers/built-in.o:(.data+0x54c40): undefined reference to `cx2341x_mpeg_ctrls'
6.22user 1.55system 0:03.08elapsed 251%CPU (0avgtext+0avgdata 0maxresident)k
