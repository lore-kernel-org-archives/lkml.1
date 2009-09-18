Return-Path: <linux-kernel-owner+w=401wt.eu-S1758505AbZIRSoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505AbZIRSoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 14:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757914AbZIRSow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 14:44:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:5702 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757789AbZIRSov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 14:44:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,411,1249282800"; 
   d="scan'208";a="449742692"
Subject: Re: [Ilw] Re: WARNING: at net/mac80211/scan.c:267
 ieee80211_scan_completed+0x299/0x2b0 [mac80211]()
From: reinette chatre <reinette.chatre@intel.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <8db1092f0909162332r4ffeef09jdb87f7fc69ff8e9e@mail.gmail.com>
References: <8db1092f0909160236i5d2b1f31k3ec289fbd9ac0bfa@mail.gmail.com>
	 <1253122055.26521.431.camel@rc-desk>
	 <8db1092f0909161036t5bae781eqa6f0a0df308ec4cd@mail.gmail.com>
	 <1253124149.26521.438.camel@rc-desk>
	 <8db1092f0909161259i5e007282i42f426bc2d0fc0c4@mail.gmail.com>
	 <1253139186.26521.449.camel@rc-desk>
	 <8db1092f0909162332r4ffeef09jdb87f7fc69ff8e9e@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 11:44:54 -0700
Message-Id: <1253299494.26521.664.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maciej,

On Wed, 2009-09-16 at 23:32 -0700, Maciej Rutecki wrote:

> [  249.340094] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
> [  249.345339] wlan0 direct probe responded
> [  249.345347] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
> [  249.347122] wlan0: authenticated
> [  249.347152] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
> [  249.349703] wlan0: RX AssocResp from 00:1b:11:f6:0f:28 (capab=0x431
> status=0 aid=1)
> [  249.349711] wlan0: associated
> [  253.411858] wlan0: deauthenticated from 00:1b:11:f6:0f:28 (Reason:
> 6)

This still appears to be the main issue here, that AP deauthenticates.
Could you run wpa_supplicant with debugging (-dddt) ? When you have
these logs, could you please open a bug report at
http://bugzilla.intellinuxwireless.org/ to enable us to track it?

Thank you

Reinette


