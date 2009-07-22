Return-Path: <linux-kernel-owner+w=401wt.eu-S1754912AbZGVNUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912AbZGVNUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbZGVNUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:20:11 -0400
Received: from mga05.intel.com ([192.55.52.89]:22946 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752056AbZGVNUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:20:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,247,1246863600"; 
   d="scan'208";a="710033793"
Message-ID: <4A671206.500@linux.intel.com>
Date: Wed, 22 Jul 2009 15:20:06 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       Taketoshi Sakuraba <taketoshi.sakuraba.hc@hitachi.com>
Subject: Re: [PATCH] x86, mce: Rename incorrect macro name "CONFIG_X86_THRESHOLD"
References: <4A667FD4.3010509@hitachi.com> <4A668964.5040800@jp.fujitsu.com>
In-Reply-To: <4A668964.5040800@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> It seems that this ifdef was introduced by the following merge commit:

I also managed to introduce similar bugs during merges in the past.
It's very easy and hard to find.

Perhaps it would be good if we had some automated tool that checks
all CONFIG_*s referenced exist in Kconfig and that is run regularly.

-Andi
