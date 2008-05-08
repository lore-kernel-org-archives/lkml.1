Return-Path: <linux-kernel-owner+w=401wt.eu-S1761598AbYEHJ3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761598AbYEHJ3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 05:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYEHJ3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 05:29:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35611 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbYEHJ3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 05:29:34 -0400
Date: Thu, 8 May 2008 11:29:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080508092918.GA32717@elte.hu>
References: <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org> <1210214696.3453.87.camel@ymzhang> <20080508064340.GA27452@elte.hu> <1210230883.3453.127.camel@ymzhang> <20080508073924.GA30356@elte.hu> <1210236254.3453.137.camel@ymzhang> <20080508092102.GA32164@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508092102.GA32164@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0003]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> plus a tty tidbit as well, during the test i saw a few of these:
> 
>  Warning: dev (tty1) tty->count(639) != #fd's(638) in release_dev

false alarm there - these were due to the breakage in the hack-patch i 
used ...

	Ingo
