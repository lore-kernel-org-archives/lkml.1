Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab0BJAcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 19:32:13 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35777 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab0BJAcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 19:32:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: tracking memory usage/leak in "inactive" field in /proc/meminfo?
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
In-Reply-To: <4B71927D.6030607@nortel.com>
References: <4B71927D.6030607@nortel.com>
Message-Id: <20100210093140.12D9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 10 Feb 2010 09:32:07 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> I'm hoping you can help me out.  I'm on a 2.6.27 x86 system and I'm
> seeing the "inactive" field in /proc/meminfo slowly growing over time to
> the point where eventually the oom-killer kicks in and starts killing
> things.  The growth is not evident in any other field in /proc/meminfo.
> 
> I'm trying to figure out where the memory is going, and what it's being
> used for.
> 
> As I've found, the fields in /proc/meminfo don't add up...in particular,
> active+inactive is quite a bit larger than
> buffers+cached+dirty+anonpages+mapped+pagetables+vmallocused.  Initially
> the difference is about 156MB, but after about 13 hrs the difference is
> 240MB.
> 
> How can I track down where this is going?  Can you suggest any
> instrumentation that I can add?
> 
> I'm reasonably capable, but I'm getting seriously confused trying to
> sort out the memory subsystem.  Some pointers would be appreciated.

can you please post your /proc/meminfo?



