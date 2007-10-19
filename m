Return-Path: <linux-kernel-owner+w=401wt.eu-S1765893AbXJSDJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765893AbXJSDJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 23:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbXJSDJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 23:09:35 -0400
Received: from rtr.ca ([76.10.145.34]:3877 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbXJSDJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 23:09:34 -0400
Message-ID: <47181FEC.4050102@rtr.ca>
Date: Thu, 18 Oct 2007 23:09:32 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: kristen.c.accardi@intel.com, greg@kroah.com,
       Andrew Morton <akpm@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       pcihpd-discuss@lists.sourceforge.net
Subject: Re: [Pcihpd-discuss] [PATCH 1/3] pciehp: hotplug: deal with pre-inserted
 ExpressCards
References: <4716CB9D.6080503@rtr.ca> <4716D3C0.20808@rtr.ca> <47174069.9000108@jp.fujitsu.com> <4717602E.2080903@rtr.ca> <4718189A.4040609@jp.fujitsu.com>
In-Reply-To: <4718189A.4040609@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kenji Kaneshige wrote:
>
>  - When the card is inserted *after* modprobing pciehp, the card
>    is *not* automatically powered on/detected. So it is very
>    natural that the card, which had been inserted before modprobing
>    pciehp, is not automatically enabled at the pciehp modprobe time.


Not true.  Once pciehp is loaded, it automatically detects and handles
inserted and removed cards just fine.  Until after the next suspend/resume.

Cheers
