Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbZHUAiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbZHUAiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 20:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZHUAiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 20:38:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38501 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbZHUAiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 20:38:03 -0400
Date: Fri, 21 Aug 2009 02:38:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alex Chiang <achiang@hp.com>,
       "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add /proc/cpuinfo/physical id quirks
Message-ID: <20090821003804.GE29994@basil.fritz.box>
References: <20090814163618.GQ7185@ldl.fc.hp.com> <1250276831.3077.17.camel@sbs-t61.sc.intel.com> <20090814192730.GA6431@ldl.fc.hp.com> <1250279799.3077.41.camel@sbs-t61.sc.intel.com> <20090819210251.GD13061@ldl.fc.hp.com> <1250794594.2754.10.camel@sbs-t61.sc.intel.com> <20090820205425.GF13061@ldl.fc.hp.com> <20090820210342.GC29994@basil.fritz.box> <1250803348.2754.26.camel@sbs-t61.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250803348.2754.26.camel@sbs-t61.sc.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If we really think overloading the "physical id" helps with existing
> software, then I am ok with changing the user visible part of the /proc/
> or /sys files but not with the kernel's per cpu info's phys_proc_id,
> which is used for topology detection etc.

It's not just the cpuinfo, but also the socketid reported for
machine check. But yes converting it only for those two 
would be a possibility.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
