Return-Path: <linux-kernel-owner+w=401wt.eu-S934285AbZHEMs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934285AbZHEMs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 08:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933416AbZHEMsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 08:48:25 -0400
Received: from mga06.intel.com ([134.134.136.21]:26328 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933395AbZHEMsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 08:48:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,328,1246863600"; 
   d="scan'208";a="538774811"
Message-ID: <4A797F95.30906@linux.intel.com>
Date: Wed, 05 Aug 2009 14:48:21 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
CC: "H.Peter Anvin" <hpa@zytor.com>, LKLM <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: Re: [PATCH] x86, mce: cleanup initcall of debugfs for mce
References: <4A77CEAB.4030909@np.css.fujitsu.com> <4A77FCCC.7040608@linux.intel.com> <4A794A4E.2060802@np.css.fujitsu.com>
In-Reply-To: <4A794A4E.2060802@np.css.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jin Dongming wrote:
> Andi Kleen wrote:
>> Sorry but I think it's better to have an own initcall per file,
>> that makes everything more self contained and easier to read.
>>
>> -Andi
>>
> Thank you for your comment.
> 
> That's OK, but this patch is also used for resolving compile error
> without CONFIG_DEBUG_FS.  Then how about this patch?


Compiler errors should be always fixed of course. But did you check
the compile error is still in the latest version of the x86/mce branch
of
git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git
It might be fixed already.

-Andi

