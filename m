Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbYDAIil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbYDAIil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 04:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbYDAIic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 04:38:32 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57948 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264AbYDAIib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 04:38:31 -0400
Date: Tue, 01 Apr 2008 17:38:10 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: OOM (HighMem) on linux 2.6.24.2
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <peterz@infradead.org>,
       Kevin Shanahan <kmshanah@ucwb.org.au>, linux-kernel@vger.kernel.org
In-Reply-To: <200804011017.35352.vda.linux@googlemail.com>
References: <1207025847.8514.675.camel@twins> <200804011017.35352.vda.linux@googlemail.com>
Message-Id: <20080401173400.1711.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> > > I kno that people routinely forget to do that, but
> > > at least for purely paranoid reasons you are better
> > > to run all daemons with setrlimit'ed memory size.
> > > At least all daemons which you cannot reasonably
> > > trust to be 100% leak-free and to have bounded
> > > peak memory usage.
> > 
> > Afaik we don't actually implement RLIMIT_RSS.
> 
> I don't know, but the following definitely works for me:
> 
> # softlimit -a 12000000 ./oom

probably you restrict virtuan address space, not rss.
but IMHO its restricsion can solve originaly problem.

Thanks

