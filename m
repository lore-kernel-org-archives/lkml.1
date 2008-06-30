Return-Path: <linux-kernel-owner+w=401wt.eu-S1762839AbYF3TQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762839AbYF3TQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbYF3TQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:16:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52266 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbYF3TQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:16:46 -0400
Date: Mon, 30 Jun 2008 21:16:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86 boot: add E820_RESVD_KERN
Message-ID: <20080630191628.GA15366@elte.hu>
References: <86802c440806260247p19f5b850r8757c51280912ae9@mail.gmail.com> <86802c440806261922n3f13b454o5e543e28d9a34e8e@mail.gmail.com> <1214534894.10865.6.camel@caritas-dev.intel.com> <86802c440806271505n78275758re235ef6616d95b3d@mail.gmail.com> <1214809434.2887.8.camel@caritas-dev.intel.com> <86802c440806300034x5bb9b7a1s168bbeaee17e5124@mail.gmail.com> <1214812303.3187.10.camel@caritas-dev.intel.com> <86802c440806300215w31abbcb3h6a42395e11701713@mail.gmail.com> <1214818706.23677.8.camel@caritas-dev.intel.com> <86802c440806301205y35563326rd2ada495a0024441@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440806301205y35563326rd2ada495a0024441@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> > For find_e820_area, this is safe enough. But what about conflict 
> > between setup_data and ebda or ramdisk?
> 
> can you have setup_data and ebda at the same time?
> 
> setup_data and ramdisk should be ok, because bootloader is supposed to 
> make them not to be conflicts.

the more sanity checks we do before relying on some crutial data, the 
better. It's easier to panic or sanitize data in some structured way and 
complain about it in the syslog than to let things get corrupted. Boot 
loaders are ... not unknown to be have bugs too, at times.

	Ingo
