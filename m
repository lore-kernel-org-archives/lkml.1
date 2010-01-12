Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770Ab0ALBnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab0ALBnG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 20:43:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751264Ab0ALBnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 20:43:05 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51445 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab0ALBnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 20:43:04 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 12 Jan 2010 10:39:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       "Zheng, Shaohui" <shaohui.zheng@intel.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "y-goto@jp.fujitsu.com" <y-goto@jp.fujitsu.com>,
       Dave Hansen <haveblue@us.ibm.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH - resend] Memory-Hotplug: Fix the bug on interface
 /dev/mem for 64-bit kernel(v1)
Message-Id: <20100112103944.a9b1db76.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4B4BD281.4080009@linux.intel.com>
References: <DA586906BA1FFC4384FCFD6429ECE86031560BAC@shzsmsx502.ccr.corp.intel.com>
	<20100108124851.GB6153@localhost>
	<DA586906BA1FFC4384FCFD6429ECE86031560FC1@shzsmsx502.ccr.corp.intel.com>
	<20100111124303.GA21408@localhost>
	<20100112093031.0fc6877f.kamezawa.hiroyu@jp.fujitsu.com>
	<4B4BD281.4080009@linux.intel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jan 2010 02:38:09 +0100
Andi Kleen <ak@linux.intel.com> wrote:

> 
> > Hmmm....could you rewrite /dev/mem to use kernel/resource.c other than
> > modifing e820 maps. ?
> 
> Sorry but responding to bug fixes with "could you please rewrite ..."  is
> not considered fair. Shaohui is just trying to fix a bug here, not redesigning
> a subsystem.
> 
Quick hack for bug fix is okay to me. 

About this patch, I'm not sure whether we are allowed to rewrite e820map after
boot.

Thanks,
-Kame

