Return-Path: <linux-kernel-owner+w=401wt.eu-S935219AbXJSDbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935219AbXJSDbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 23:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760580AbXJSDbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 23:31:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:32814 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758673AbXJSDbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 23:31:44 -0400
Message-ID: <47182429.1080103@jp.fujitsu.com>
Date: Fri, 19 Oct 2007 12:27:37 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
Cc: kristen.c.accardi@intel.com, greg@kroah.com,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [Pcihpd-discuss] [PATCH 1/3] pciehp: hotplug: deal with pre-inserted
 ExpressCards
References: <4716CB9D.6080503@rtr.ca> <4716D3C0.20808@rtr.ca> <47174069.9000108@jp.fujitsu.com> <4717602E.2080903@rtr.ca> <4718189A.4040609@jp.fujitsu.com> <47181FEC.4050102@rtr.ca>
In-Reply-To: <47181FEC.4050102@rtr.ca>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord さんは書きました:
> Kenji Kaneshige wrote:
>>
>>  - When the card is inserted *after* modprobing pciehp, the card
>>    is *not* automatically powered on/detected. So it is very
>>    natural that the card, which had been inserted before modprobing
>>    pciehp, is not automatically enabled at the pciehp modprobe time.
> 
> 
> Not true.  Once pciehp is loaded, it automatically detects and handles
> inserted and removed cards just fine.  Until after the next suspend/resume.
> 

This is because your slot is surprise remove capable. On my slot,
which is not surprise remove capable, the card is not enabled
even after pciehp is loaded.

Thanks,
Kenji Kaneshige


