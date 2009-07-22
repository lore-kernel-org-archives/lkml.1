Return-Path: <linux-kernel-owner+w=401wt.eu-S1752375AbZGVPif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbZGVPif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZGVPie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:38:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40474 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbZGVPie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:38:34 -0400
Message-ID: <4A671F54.7050101@zytor.com>
Date: Wed, 22 Jul 2009 07:16:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.1) Gecko/20090715 Thunderbird/3.0b3
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       Taketoshi Sakuraba <taketoshi.sakuraba.hc@hitachi.com>
Subject: Re: [PATCH] x86, mce: Rename incorrect macro name "CONFIG_X86_THRESHOLD"
References: <4A667FD4.3010509@hitachi.com> <4A668964.5040800@jp.fujitsu.com> <4A671206.500@linux.intel.com>
In-Reply-To: <4A671206.500@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2009 06:20 AM, Andi Kleen wrote:
> 
>> It seems that this ifdef was introduced by the following merge commit:
> 
> I also managed to introduce similar bugs during merges in the past.
> It's very easy and hard to find.
> 
> Perhaps it would be good if we had some automated tool that checks
> all CONFIG_*s referenced exist in Kconfig and that is run regularly.

There is checkkconfigsymbols.sh...

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

