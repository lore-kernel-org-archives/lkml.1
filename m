Return-Path: <linux-kernel-owner+w=401wt.eu-S936214AbYD1QJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936214AbYD1QJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933630AbYD1QJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:09:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:8782 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763850AbYD1QJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:09:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,717,1199692800"; 
   d="scan'208";a="377668037"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
Date: Mon, 28 Apr 2008 09:09:06 -0700
User-Agent: KMail/1.9.9
Cc: Gabriel C <nix.or.die@googlemail.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Mika Fischer <mika.fischer@zoopnet.de>, balajirrao@gmail.com,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
References: <200801192045.17291.yinghai.lu@sun.com> <48159ECF.9020004@googlemail.com> <20080428135351.GF3973@elte.hu>
In-Reply-To: <20080428135351.GF3973@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804280909.06561.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 28, 2008 6:53 am Ingo Molnar wrote:
> i think we should still try to make this a non-default option because
> modern Xorg should not have any need to touch MTRRs. Perhaps a .config
> dependent on CONFIG_DANGEROUS ;-)

Well, not quite... we're still waiting on some way of getting WC semantics for 
sysfs PCI files.  Suresh tells me something like that is queued up, but until 
that hits the mainline X will still need to bang the MTRRs to get decent 
performance.

Jesse
