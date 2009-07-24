Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbZGXGnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbZGXGnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 02:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbZGXGns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 02:43:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:41242 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbZGXGnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 02:43:47 -0400
Message-ID: <4A695897.2020902@kernel.org>
Date: Fri, 24 Jul 2009 15:45:43 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>
CC: "Luck, Tony" <tony.luck@intel.com>,
       "'lkml'" <linux-kernel@vger.kernel.org>,
       "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>,
       "'linux-ia64@vger.kernel.org'" <linux-ia64@vger.kernel.org>
Subject: Re: [RFC PATCH] ia64: convert to dynamic percpu allocator
References: <4A65B0AB.5000608@kernel.org> <A6AD88C3F2289247BE726C37303E1EB8B097D4C5@orsmsx505.amr.corp.intel.com> <4A663DC7.4060600@kernel.org> <A6AD88C3F2289247BE726C37303E1EB8B0A9115B@orsmsx505.amr.corp.intel.com>
In-Reply-To: <A6AD88C3F2289247BE726C37303E1EB8B0A9115B@orsmsx505.amr.corp.intel.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 24 Jul 2009 06:43:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Yu, Fenghua wrote:

> After cloning from
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git, kernel
> built with CONFIG_DISCONTIGMEM=y boots ok.
> 
> After pulling from review-ia64, kernel built with
> CONFIG_DISCONTIGMEM=y can not boot on ia64. After loading kernel and
> initrd, system hangs and doesn't show anything on serial port.

Heh, I didn't really expect it to work that easily either.  The code
builds but is completely untested (I can't test them).  Can you try to
track it down?  Serial console should be up and running at that point,
no?

Thanks.

-- 
tejun
