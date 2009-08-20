Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbZHTVDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbZHTVDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 17:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZHTVDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 17:03:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40285 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbZHTVDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 17:03:44 -0400
Date: Thu, 20 Aug 2009 23:03:42 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alex Chiang <achiang@hp.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add /proc/cpuinfo/physical id quirks
Message-ID: <20090820210342.GC29994@basil.fritz.box>
References: <20090814163618.GQ7185@ldl.fc.hp.com> <1250276831.3077.17.camel@sbs-t61.sc.intel.com> <20090814192730.GA6431@ldl.fc.hp.com> <1250279799.3077.41.camel@sbs-t61.sc.intel.com> <20090819210251.GD13061@ldl.fc.hp.com> <1250794594.2754.10.camel@sbs-t61.sc.intel.com> <20090820205425.GF13061@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820205425.GF13061@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am leaning towards sysfs, and prefer:
> 
>  	/sys/devices/system/cpu/$cpu/chassis_id
> 
> How does that sound?

I would prefer to simply use the existing physical id for this like
in your original patch.  We already have a bewildering zoo of different
CPU IDs, no need to increase the confusion even more.

Incidentially mcelog already knows how to use physical ID for this,
would need to be changed for a new sysfs interface

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
