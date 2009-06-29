Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbZF2SIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbZF2SIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbZF2SI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:08:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:10157 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbZF2SI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:08:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,310,1243839600"; 
   d="scan'208";a="426260135"
Subject: Re: iwl3945 in 2.6.31-rc0: ad-hoc mode broken?
From: reinette chatre <reinette.chatre@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20090619222431.GA2398@elf.ucw.cz>
References: <20090619222431.GA2398@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 11:08:28 -0700
Message-Id: <1246298908.17896.391.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Fri, 2009-06-19 at 15:24 -0700, Pavel Machek wrote:
> I tried using ad-hoc mode (against t-mobile G1) on -rc0, and was
> unsuccessful -- never got dhcp. I had to reboot back to
> 2.6.30... Should I try it few more times or is something broken?

I have tried ad-hoc mode in 2.6.31-rc1
(52989765629e7d182b4f146050ebba0abf2cb0b7) and did not have issues. I
tested ad-hoc between 3945 (iwl3945) and 5100 (iwlagn), testing that
both are able to create the IBSS network and both are able to join
another IBSS network.

Do you get any errors? Is it just the dhcp that fails (does association
succeed?) mac80211 does have extra debugging for ad-hoc that can be
enabled with CONFIG_MAC80211_IBSS_DEBUG=y. Could you please try that?

> 
> (Also wifi LED stopped working on x60, but that's older issue).

Is there a bug report for this?

Reinette


