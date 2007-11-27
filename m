Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbXK0Qxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbXK0Qxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 11:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757047AbXK0Qxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 11:53:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:43423 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756212AbXK0Qxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 11:53:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,220,1194249600"; 
   d="scan'208";a="280987393"
Message-ID: <474C4A74.90705@intel.com>
Date: Tue, 27 Nov 2007 08:48:52 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: e1000 driver problems
References: <20061017205316.25914.qmail@web83109.mail.mud.yahoo.com> <45354850.6050900@intel.com> <20071120143803.GA5638@ics.muni.cz> <474B5610.4030800@intel.com> <20071127150700.GB4365@ics.muni.cz>
In-Reply-To: <20071127150700.GB4365@ics.muni.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Nov 2007 16:49:25.0246 (UTC) FILETIME=[77B4A1E0:01C83115]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Hejtmanek wrote:
> On Mon, Nov 26, 2007 at 03:26:08PM -0800, Kok, Auke wrote:
>> The fix for this has been to grant more time for the hardware to recover
>> from this busy state. I'll make sure to check if the upstream drivers are OK
>> in this regard.
>>
>> you can try our out-of-tree e1000 driver (7.6.x or newer) which should work
>> OK for you with respect to this problem. Please give that a try.
> 
> unfortunately, the 7.6.9 driver cannot be compiled with 2.6.24-rc3-git2
> kernel due to compilation errors.

but the in-kernel version of e1000 supports the ich8 lan device just fine and can
be builtin. also this kernel has the first release of e1000e which supports the
ich9 onboard lan device.

Auke
