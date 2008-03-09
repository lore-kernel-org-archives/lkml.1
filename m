Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139AbYCIMvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139AbYCIMvs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 08:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYCIMvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 08:51:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38852 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbYCIMvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 08:51:38 -0400
Date: Sun, 09 Mar 2008 21:51:08 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: quicklists confuse meminfo
Cc: kosaki.motohiro@jp.fujitsu.com, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
In-Reply-To: <20080309123432.GA3267@elte.hu>
References: <20080309120940.GA1695@elte.hu> <20080309123432.GA3267@elte.hu>
Message-Id: <20080309214951.C6E4.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> hm, Thomas pointed it out that this wont solve all the problems as 
> quicklists have a built-in "preserve me" throttle (which is rather 
> stupid).
> 
> the right solution is to get rid of quicklists altogether (Thomas 
> expects to have patches for that later today).
> 
> If anyone implements a _sane_ general purpose allocator that can 
> preserve constructed objects then i'm all for utilizing it in x86 too, 
> but quicklists arent that mechanism ...

Apparently, my patch seems to have been too late ;)
please forget it.


- kosaki


