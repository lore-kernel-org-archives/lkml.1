Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbYLZCmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbYLZCmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 21:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbYLZCmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 21:42:13 -0500
Received: from mga10.intel.com ([192.55.52.92]:59569 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752658AbYLZCmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 21:42:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,283,1228118400"; 
   d="scan'208";a="417499276"
Message-ID: <49544497.9020900@linux.intel.com>
Date: Fri, 26 Dec 2008 03:42:31 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
       Robert Richter <robert.richter@amd.com>, venkatesh.pallipadi@intel.com
Subject: Re: 2.6.28-rc9: oprofile regression
References: <1229869416.6911.1.camel@thinkpad> <1229894585.6898.6.camel@thinkpad>
In-Reply-To: <1229894585.6898.6.camel@thinkpad>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Blechmann wrote:
>> i am experiencing an issue, similar to the one reported in
>> http://lkml.org/lkml/2008/10/30/319.
> 
> bisecting showed, that commit b99170288421c79f0c2efa8b33e26e65f4bb7fb8
> (oprofile: Implement Intel architectural perfmon support) caused the
> problem. 
> oddly, the newly introduced api is not used, since the model struct is
> set during the ppro_init call ...

We're still investigating the problem. Thanks for the report.

-Andi
