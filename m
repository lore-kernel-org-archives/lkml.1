Return-Path: <linux-kernel-owner+w=401wt.eu-S934695AbYBGWe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934695AbYBGWe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758826AbYBGWeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:34:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:36232 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757015AbYBGWeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:34:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,318,1199692800"; 
   d="scan'208";a="257050588"
Message-ID: <47AB86F0.9060601@intel.com>
Date: Thu, 07 Feb 2008 14:32:16 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>,
       e1000-devel@lists.sourceforge.net, john.ronciak@intel.com,
       jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [E1000-devel] e1000 1sec latency problem
References: <20080207141718.GA2030@elf.ucw.cz> <47AB4B2E.1030801@intel.com> <20080207222411.GA1917@elf.ucw.cz>
In-Reply-To: <20080207222411.GA1917@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>> I have the famous e1000 latency problems:
>>>
>>> 64 bytes from 195.113.31.123: icmp_seq=68 ttl=56 time=351.9 ms
>>> 64 bytes from 195.113.31.123: icmp_seq=69 ttl=56 time=209.2 ms
>>> 64 bytes from 195.113.31.123: icmp_seq=70 ttl=56 time=1004.1 ms
>>> 64 bytes from 195.113.31.123: icmp_seq=71 ttl=56 time=308.9 ms
>>> 64 bytes from 195.113.31.123: icmp_seq=72 ttl=56 time=305.4 ms
>>> 64 bytes from 195.113.31.123: icmp_seq=73 ttl=56 time=9.8 ms
>>> 64 bytes from 195.113.31.123: icmp_seq=74 ttl=56 time=3.7 ms
>>>
>>> ...and they are still there in 2.6.25-git0. I had ethernet EEPROM
>>> checksum problems, which I fixed by the update, but problems are not
>>> gone.
>> pavel, start using "e1000e" instead - this driver replaces e1000 for all the
>> pci-express devices and has the infamous L1 ASPM disable patch to
>> fix this issue.
> 
> Ok, e1000e seems to work for me.
> 
> In another email, you asked for lspci -vvvv of failing e1000
> case. Should I still provide it?

well, if you do it you should see that L1 ASPM is now disabled (with e1000e)
whereas with e1000 it is still enabled. That's the fix that you need...

Auke
