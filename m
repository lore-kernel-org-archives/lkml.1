Return-Path: <linux-kernel-owner+w=401wt.eu-S1751535AbZLOBiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbZLOBiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbZLOBiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:38:22 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53301 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbZLOBiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:38:21 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with nodemask v4.2
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20091215103202.eacfd64e.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091214171632.0b34d833.akpm@linux-foundation.org> <20091215103202.eacfd64e.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20091215103739.CDCA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 15 Dec 2009 10:38:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 14 Dec 2009 17:16:32 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > So I have a note-to-self here that these patches:
> > 
> > oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
> > oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
> > oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
> > 
> > are tentative and it was unclear whether I should merge them.
> > 
> > What do we think?
> 
> In my view,
>   oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
>   - should be merged.
> 
>   oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
>   - should be merged.
> 
>   oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
>   - should not be merged.

all agree.



