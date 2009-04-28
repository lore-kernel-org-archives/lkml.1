Return-Path: <linux-kernel-owner+w=401wt.eu-S1760397AbZD1Hoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760397AbZD1Hoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 03:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760105AbZD1Hoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 03:44:34 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44661 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898AbZD1Hod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 03:44:33 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Elladan <elladan@eskimo.com>
Subject: Re: Swappiness vs. mmap() and interactive response
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20090428072619.GA29747@eskimo.com>
References: <20090428154835.EBC9.A69D9226@jp.fujitsu.com> <20090428072619.GA29747@eskimo.com>
Message-Id: <20090428164050.EBD2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 28 Apr 2009 16:44:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Apr 28, 2009 at 03:52:29PM +0900, KOSAKI Motohiro wrote:
> > Hi
> > 
> > > 3. cache limitation of memcgroup solve this problem?
> > > 
> > > I was unable to get this to work -- do you have some documentation handy?
> > 
> > Do you have kernel source tarball?
> > Documentation/cgroups/memory.txt explain usage kindly.
> 
> Thank you.  My documentation was out of date.
> 
> I created a cgroup with limited memory and placed a copy command in it, and the
> latency problem seems to essentially go away.  However, I'm also a bit
> suspicious that my test might have become invalid, since my IO performance
> seems to have dropped somewhat too.
> 
> So, am I right in concluding that this more or less implicates bad page
> replacement as the culprit?  After I dropped vm caches and let my working set
> re-form, the memory cgroup seems to be effective at keeping a large pool of
> memory free from file pressure.

Hmm..
it seems your result mean bad page replacement occur. but actually
I hevn't seen such result on my environment.

Hmm, I think I need to make reproduce environmet to your trouble.

Thanks.



