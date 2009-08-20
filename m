Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbZHTV1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbZHTV1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754579AbZHTV1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:27:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:35169 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303AbZHTV1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:27:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,416,1246863600"; 
   d="scan'208";a="485752961"
Subject: Re: [PATCH] x86: add /proc/cpuinfo/physical id quirks
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alex Chiang <achiang@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090820212024.GG13061@ldl.fc.hp.com>
References: <20090814163618.GQ7185@ldl.fc.hp.com>
	 <1250276831.3077.17.camel@sbs-t61.sc.intel.com>
	 <20090814192730.GA6431@ldl.fc.hp.com>
	 <1250279799.3077.41.camel@sbs-t61.sc.intel.com>
	 <20090819210251.GD13061@ldl.fc.hp.com>
	 <1250794594.2754.10.camel@sbs-t61.sc.intel.com>
	 <20090820205425.GF13061@ldl.fc.hp.com>
	 <20090820210342.GC29994@basil.fritz.box>
	 <20090820212024.GG13061@ldl.fc.hp.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 20 Aug 2009 14:26:17 -0700
Message-Id: <1250803577.2754.30.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 14:20 -0700, Alex Chiang wrote:
> It turns out I need to rework my patch anyway because I need to
> think about the case where a user disables some cores in the
> BIOS, in which case my (fragile) table selection scheme falls
> apart.

These are the sort of reasons why we want topology detection to be
completely based on what cpuid instruction says and nothing else.

thanks,
suresh

