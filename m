Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYGCMMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYGCMMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYGCMMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:12:07 -0400
Received: from fgwmail8.fujitsu.co.jp ([192.51.44.38]:56177 "EHLO
	fgwmail8.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbYGCMMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:12:05 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Jul 2008 08:12:03 EDT
Date: Thu, 03 Jul 2008 18:38:52 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [mmotm] build failure on x86_64 pci-calgary_64.c
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, npiggin@suse.de,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik Van Riel <riel@redhat.com>
In-Reply-To: <20080703090722.GA17350@elte.hu>
References: <20080703174027.D6D7.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080703090722.GA17350@elte.hu>
Message-Id: <20080703182244.D6DC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I guess below commit or related commit is doubtfully.
> > 
> > :commit 1b1b18f0bf62ec808784002382f2b5833701afda
> > :Author: Yinghai Lu <yhlu.kernel@gmail.com>
> > :Date:   Tue Jun 24 22:14:09 2008 -0700
> > :
> > :    x86: remove end_pfn in 64bit
> > :
> > :    and use max_pfn directly.
> > :
> > :    Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> > :    Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> no.
> 
> this a linux-next integration artifact AFAICT, there's no such build 
> failure in the x86 tree.
> 
> what happened is that the x86 tree got rid of end_pfn, the PCI tree grew 
> one more reference to it and it was not fixed up.

sorry ;)

btw: I confirmed 2.6.26-rc8-mm1 (contain Andrew's end_pfx fix) works well.


