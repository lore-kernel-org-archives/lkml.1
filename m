Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbZI1SYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbZI1SYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 14:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbZI1SYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 14:24:17 -0400
Received: from mga12.intel.com ([143.182.124.36]:7758 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752454AbZI1SYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 14:24:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,468,1249282800"; 
   d="scan'208";a="192559668"
Message-ID: <4AC0FF58.5040302@linux.intel.com>
Date: Mon, 28 Sep 2009 20:24:24 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] x86, mce: rename finished to valid in struct mce
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com> <4AC05BBF.3010102@jp.fujitsu.com> <4AC05CFC.4020702@jp.fujitsu.com>
In-Reply-To: <4AC05CFC.4020702@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:
> The straightforward name is easier to understand.

struct mce is exported to user space. I don't think it's a good idea
to rename fields in exported structures like this.  That just causes confusion.

-Andi
