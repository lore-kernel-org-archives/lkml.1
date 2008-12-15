Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbYLOCFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbYLOCFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 21:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbYLOCF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 21:05:28 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52156 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbYLOCF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 21:05:28 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: 2.6.28-rc8 big regression in VM
Cc: kosaki.motohiro@jp.fujitsu.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20081215011645.GA9707@localhost>
References: <20081213095815.GA7143@ics.muni.cz> <20081215011645.GA9707@localhost>
Message-Id: <20081215110231.00DF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon, 15 Dec 2008 11:05:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lukas

(cc to linux-mm)

> On Sat, Dec 13, 2008 at 11:58:15AM +0200, Lukas Hejtmanek wrote:
> > On Sat, Dec 13, 2008 at 09:21:15AM +0800, Wu Fengguang wrote:
> > > I cannot reproduce it on 2.6.28-rc7, compiling 2.6.28-rc8...
> > > 
> > > # free; echo 3 > /proc/sys/vm/drop_caches; free
> > >              total       used       free     shared    buffers     cached
> > > Mem:          1940        109       1831          0          0         42
> > > -/+ buffers/cache:         66       1873
> > > Swap:            0          0          0
> > >              total       used       free     shared    buffers     cached
> > > Mem:          1940         62       1877          0          0          7
> > > -/+ buffers/cache:         55       1884
> > > Swap:            0          0          0
> > > 
> > > > once the whole memory is eaten by the cache, the system is pretty unusable.
> > > 
> > > What's your kconfig?
> > 
> > attached.

I also don't reproduce your problem.
Could you get output of "cat /proc/meminfo", not only free command?



