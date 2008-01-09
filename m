Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYAIJe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYAIJe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 04:34:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbYAIJeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 04:34:14 -0500
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:11658 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306AbYAIJeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 04:34:12 -0500
To: Len Brown <lenb@kernel.org>
Subject: Re: pnpacpi : exceeded the max number of IO resources
Cc: akpm@osdl.org, bjorn.helgaas@hp.com, cholvenstot@comcast.net,
       hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
       rene.herman@keyaccess.nl, shaohua.li@intel.com, trenn@suse.de,
       yakui.zhao@intel.com
In-reply-To: <200801082250.51026.lenb@kernel.org>
References: <1196428488.7066.6.camel@localhost> <47508D3C.9050507@keyaccess.nl> <475436A3.90906@keyaccess.nl> <200801082250.51026.lenb@kernel.org>
Message-Id: <E1JCXK5-0002GH-0x@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Wed, 09 Jan 2008 10:34:09 +0100
X-OriginalArrivalTime: 09 Jan 2008 09:34:09.0339 (UTC) FILETIME=[C92CB8B0:01C852A2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
>> > Well, yes, the warning is actually new as well. Previously your kernel
>> > just silently ignored 8 more mem resources than it does now it seems.
>> > 
>> > Given that people are hitting these limits, it might make sense to just
>> > do away with the warning for 2.6.24 again while waiting for the dynamic
>> > code?
>> 
>> Ping. Should these warnings be reverted for 2.6.24?
> 
> No. I don't think hiding this issue again is a good idea.
> I'd rather live with people complaining about an addition dmesg line.

We're not talking about "a" additional line. In my case [1] we're talking
about 22 (!) additional identical lines.

Not fixing this before 2.6.24 seems completely inconsistent:
- either this is a real bug and the ERR level message is correct, in which
  case the limits should be increased;
- or hitting the limits is harmless and the message should be changed to
  DEBUG level.

It is great to hear that the memory allocation will become dynamic in the
future and maybe that could just justify your standpoint, but having the
messages is damn ugly and alarming from a user point of view.

Please keep in mind that depending on distro release schedules, 2.6.24 could
live for quite a bit longer than just the period needed to release 2.6.25
(if that is when the dynamic allocation will be implemented).

Cheers,
FJP

[1] http://lkml.org/lkml/2008/1/6/279
