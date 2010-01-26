Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262Ab0AZXrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab0AZXrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238Ab0AZXrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:47:45 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50796 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755157Ab0AZXrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:47:43 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 27 Jan 2010 08:44:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, rientjes@google.com,
       minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
Message-Id: <20100127084419.248bb3a7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100126151606.54764be2.akpm@linux-foundation.org>
References: <20100121145905.84a362bb.kamezawa.hiroyu@jp.fujitsu.com>
	<20100122152332.750f50d9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100125151503.49060e74.kamezawa.hiroyu@jp.fujitsu.com>
	<20100126151606.54764be2.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010 15:16:06 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 25 Jan 2010 15:15:03 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > -unsigned long badness(struct task_struct *p, unsigned long uptime)
> > +unsigned long badness(struct task_struct *p, unsigned long uptime,
> > +			int constraint)
> 
> And badness() should be renamed to something better (eg, oom_badness), and
> the declaration should be placed in a mm-specific header file.
> 
> Yes, the code was already like that.  But please don't leave crappiness in
> place when you come across it - take the opportunity to fix it up.
> 
Sure. I'll write v4.

-Kame

