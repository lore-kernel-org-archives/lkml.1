Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbZGWBKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbZGWBKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 21:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbZGWBKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 21:10:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35057 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZGWBKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 21:10:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A67B87C.5030104@jp.fujitsu.com>
Date: Thu, 23 Jul 2009 10:10:20 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Brayan Arraes <brayan@yack.com.br>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Subject: Re: [PATCH] sysrq, kdump: fix regression, revert "simplify sysrq-c
 handler"
References: <4A64672E.8020005@cn.fujitsu.com> <4A6564F2.10404@jp.fujitsu.com> <20090721110857.GA21612@hmsreliant.think-freely.org> <4A6672F9.3050800@jp.fujitsu.com> <20090722111049.GB4539@hmsreliant.think-freely.org> <20090722134211.GA7995@redhat.com> <20090722193831.GA4718@hmsreliant.think-freely.org>
In-Reply-To: <20090722193831.GA4718@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> On Wed, Jul 22, 2009 at 09:42:11AM -0400, Vivek Goyal wrote:
>> Can't we just set panic_on_oops = 1 in sysrq_handle_crash()? This will
>> make sure that we test oops path as well as have consistent behavior
>> between two methods of sysrc-c invocation.
>>
> Thats a good point too, seems simpler than the other approach.

OK, I'll take this way.  Please wait for a moment for a patch.

Thanks,
H.Seto

