Return-Path: <linux-kernel-owner+w=401wt.eu-S1752087AbYLYJbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbYLYJbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 04:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYLYJbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 04:31:33 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:36982 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbYLYJbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 04:31:32 -0500
Date: Thu, 25 Dec 2008 10:33:01 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, akpm@linux-foundation.org, ralf@linux-mips.org,
       kernel@wantstofly.org, hskinnemoen@atmel.com, cooloney@kernel.org,
       tony.luck@intel.com, geert@linux-m68k.org, zippel@linux-m68k.org,
       jwboyer@linux.vnet.ibm.com, mporter@kernel.crashing.org,
       grant.likely@secretlab.ca, paulus@samba.org, benh@kernel.crashing.org,
       dhowells@redhat.com, yasutake.koichi@jp.panasonic.com,
       lethal@linux-sh.org, hpa@zytor.com
Subject: Re: [PATCH -tip] Switch arm defconfig files from CONFIG_CLASSIC_RCU to CONFIG_TREE_RCU.
Message-ID: <20081225093301.GB27896@uranus.ravnborg.org>
References: <1229991147545-git-send-email-paulmck@linux.vnet.ibm.com> <12299911471985-git-send-email-paulmck@linux.vnet.ibm.com> <20081223142542.GC29151@elte.hu> <20081225083611.GA14968@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225083611.GA14968@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 09:36:11AM +0100, Ingo Molnar wrote:
> 
> below is the fix for another small buglet that hits architectures that do 
> not include kernel/Kconfig.preempt.

What is needed to let all architectures include Kconfig.preempt?
We should not advertise preemption if not supported,
but we could do this by a simple Kconfig symbol:

config HAVE_PREEMPT
	bool

And let all architectures that supports preemption do:

config "ARCH"
	select HAVE_PREEMPT

But maybe there is a simpler solution

	Sam
