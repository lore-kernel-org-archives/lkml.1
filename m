Return-Path: <linux-kernel-owner+w=401wt.eu-S965280AbYD1Qba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965280AbYD1Qba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 12:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934101AbYD1QbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 12:31:21 -0400
Received: from trillian.zoopnet.de ([85.214.111.199]:52274 "EHLO
	trillian.zoopnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932950AbYD1QbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:31:20 -0400
Message-ID: <4815FBD3.6050902@zoopnet.de>
Date: Mon, 28 Apr 2008 18:31:15 +0200
From: Mika Fischer <mika.fischer@zoopnet.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jesse Barnes <jesse.barnes@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Gabriel C <nix.or.die@googlemail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       balajirrao@gmail.com, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86_32: trim memory by updating e820 v3
References: <200801192045.17291.yinghai.lu@sun.com> <48159ECF.9020004@googlemail.com> <20080428135351.GF3973@elte.hu> <200804280909.06561.jesse.barnes@intel.com>
In-Reply-To: <200804280909.06561.jesse.barnes@intel.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes schrieb:
> On Monday, April 28, 2008 6:53 am Ingo Molnar wrote:
>> i think we should still try to make this a non-default option because
>> modern Xorg should not have any need to touch MTRRs. Perhaps a .config
>> dependent on CONFIG_DANGEROUS ;-)
> 
> Well, not quite... we're still waiting on some way of getting WC semantics for 
> sysfs PCI files.  Suresh tells me something like that is queued up, but until 
> that hits the mainline X will still need to bang the MTRRs to get decent 
> performance.

Do you happen to know if this new sysfs-way will work correctly in the
case where the MTRRs explicitly say that the video-memory is uncachable?

Regards,
 Mika
