Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab0BJEJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 23:09:27 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46915 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab0BJEJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 23:09:25 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: tracking memory usage/leak in "inactive" field in /proc/meminfo?
Cc: kosaki.motohiro@jp.fujitsu.com, Chris Friesen <cfriesen@nortel.com>,
       Rik van Riel <riel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
In-Reply-To: <20100210035052.GH3290@balbir.in.ibm.com>
References: <20100210093140.12D9.A69D9226@jp.fujitsu.com> <20100210035052.GH3290@balbir.in.ibm.com>
Message-Id: <20100210130706.4D15.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 10 Feb 2010 13:09:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2010-02-10 09:32:07]:
> 
> > > Hi,
> > > 
> > > I'm hoping you can help me out.  I'm on a 2.6.27 x86 system and I'm
> > > seeing the "inactive" field in /proc/meminfo slowly growing over time to
> > > the point where eventually the oom-killer kicks in and starts killing
> > > things.  The growth is not evident in any other field in /proc/meminfo.
> > > 
> > > I'm trying to figure out where the memory is going, and what it's being
> > > used for.
> > > 
> > > As I've found, the fields in /proc/meminfo don't add up...in particular,
> > > active+inactive is quite a bit larger than
> > > buffers+cached+dirty+anonpages+mapped+pagetables+vmallocused.  Initially
> > > the difference is about 156MB, but after about 13 hrs the difference is
> > > 240MB.
> > > 
> > > How can I track down where this is going?  Can you suggest any
> > > instrumentation that I can add?
> > > 
> > > I'm reasonably capable, but I'm getting seriously confused trying to
> > > sort out the memory subsystem.  Some pointers would be appreciated.
> > 
> > can you please post your /proc/meminfo?
> 
> Do you have swap enabled? Can you help with the OOM killed dmesg log?
> Does the situation get better after OOM killing. /proc/meminfo as
> Kosaki suggested would be important as well. 

Indeed.

Chris, 2.6.27 is a bit old. plese test it on latest kernel. and please don't use
any proprietary drivers.



