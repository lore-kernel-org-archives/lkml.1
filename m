Return-Path: <linux-kernel-owner+w=401wt.eu-S932490AbZAPKgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbZAPKgX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 05:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754165AbZAPKgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 05:36:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:48040 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012AbZAPKgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 05:36:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,276,1231142400"; 
   d="scan'208";a="378995185"
Subject: Re: hardware time stamping with optional structs in data area
From: Patrick Ohly <patrick.ohly@intel.com>
To: David Miller <davem@davemloft.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
In-Reply-To: <1229352899-31330-1-git-send-email-patrick.ohly@intel.com>
References: <1229352899-31330-1-git-send-email-patrick.ohly@intel.com>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 11:36:04 +0100
Message-Id: <1232102164.18762.72.camel@pohly-MOBL>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-15 at 15:54 +0100, Patrick Ohly wrote:
> This is the third iteration of a patch series which adds a user space
> API for hardware time stamping of network packets and the
> infrastructure that implements that API. The igb driver is used as
> example for how a network driver can use this new infrastructure.

A new year, another month => time to bring this up once more. The latest
revision of the patch series hasn't brought up further requests for
improvement. There still is growing demand for this feature.

David, do you think it is ready to get included?

John acknowledged the changes to clocksource.h. clocksync is independent
of everything else and not active unless called; if driver developers
don't find it useful, it can be replaced/removed. That leaves the API,
which hasn't triggered any comments so far. As proof that it works as
intended I adapted PTPd to use it:
        http://github.com/pohly/ptpd/tree/master

If further discussion of the API is necessary to get this into mainline,
perhaps including the patches in netdev-next would help to encourage
that discussion?

Is there anything I can do myself, like rebasing against the latest
netdev-next?

Bye, Patrick

