Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbZJAAf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbZJAAf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 20:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755236AbZJAAf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 20:35:26 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:61986 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755118AbZJAAf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 20:35:26 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-wireless@vger.kernel.org
Subject: Re: [SOLVED][.32-rc1/2] ath5k: has become unreliable with .32-rc1
Date: Thu, 1 Oct 2009 02:35:27 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200909300952.29106.elendil@planet.nl>
In-Reply-To: <200909300952.29106.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910010235.28904.elendil@planet.nl>
X-OriginalArrivalTime: 01 Oct 2009 00:35:29.0395 (UTC) FILETIME=[13A4E430:01CA422F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 September 2009, Frans Pop wrote:
> The first time I booted .32-rc1 (reboot from .31-rc5), wireless came up
> without problems, but failed to come back after suspend to RAM. I could
> only get wireless back by ejecting and re-inserting the PCMCIA card.
>
> The second and third time I booted .32-rc1 (to write this report; a cold
> boot and a ".32 to .32" reboot), wireless did not come up at all.
> See attached dmesg. The last part is after 'ifup ath0'. It seems to
> associate, but then for some reason immediately deauthenticates again.

Both issues are solved with current mainline. Probably the resume issue by 
Rafael's PCMCIA patch (the "late" config restore messages for ath5k are 
back too), the boot issue by one of Johannes' patches (I'd guess either 
4be3bd8c 'cfg80211: don't set privacy w/o key' or maybe 8bb89485
'cfg80211: always get BSS').

Still strange that iwlagn continued to work. Although, come to think of it, 
I have not cold booted that laptop recently.

Cheers,
FJP
