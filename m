Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbYFYDIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbYFYDIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 23:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbYFYDIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 23:08:14 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52456 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753384AbYFYDIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 23:08:14 -0400
Date: Tue, 24 Jun 2008 22:08:10 -0500
From: Paul Jackson <pj@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: hpa@zytor.com, yhlu.kernel@gmail.com, akpm@linux-foundation.org,
       mingo@elte.hu, tglx@linutronix.de, steiner@sgi.com, travis@sgi.com,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, andi@firstfloor.org
Subject: Re: [PATCH 4/5 v2] x86 boot: show pfn addresses in hex not decimal
 in some kernel info printks
Message-Id: <20080624220810.b2ec0c6a.pj@sgi.com>
In-Reply-To: <alpine.LFD.1.10.0806241949030.13106@hp.linux-foundation.org>
References: <20080622142151.5591.4139.sendpatchset@polaris-admin.engr.sgi.com>
	<20080622142212.5591.64592.sendpatchset@polaris-admin.engr.sgi.com>
	<86802c440806221238g78300952t2fc7f406c1842273@mail.gmail.com>
	<20080623060939.6b6b3183.pj@sgi.com>
	<86802c440806241429s7f5e899dn67d42303247f618@mail.gmail.com>
	<20080624203252.f932c631.pj@sgi.com>
	<4861A5DF.5010104@zytor.com>
	<20080624211711.8c6d5105.pj@sgi.com>
	<4861AAEF.3020103@zytor.com>
	<alpine.LFD.1.10.0806241949030.13106@hp.linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus wrote:
>  %#p (which I don't think anybody uses right now

I don't see any such uses, so that could work.

I agree - that the lib/vsprintf.c code seems to prefix
"%#p" numbers with "0x", as currently coded.

But I find borrowing the '#' flag for symbolic names
to be a slight stretch, as well as likely to confuse
some of us, such as myself, for whom these printf flags
are already a tad cryptic and error prone.

I'd be inclined instead to use "%P" for symbolic addrs.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
