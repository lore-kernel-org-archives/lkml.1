Return-Path: <linux-kernel-owner+w=401wt.eu-S1751434AbZHUAcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbZHUAcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 20:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbZHUAcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 20:32:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44344 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbZHUAcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 20:32:35 -0400
Date: Fri, 21 Aug 2009 02:32:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Alex Chiang <achiang@hp.com>,
       Andi Kleen <andi@firstfloor.org>, "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add /proc/cpuinfo/physical id quirks
Message-ID: <20090821003232.GD29994@basil.fritz.box>
References: <1250276831.3077.17.camel@sbs-t61.sc.intel.com> <20090814192730.GA6431@ldl.fc.hp.com> <1250279799.3077.41.camel@sbs-t61.sc.intel.com> <20090819210251.GD13061@ldl.fc.hp.com> <1250794594.2754.10.camel@sbs-t61.sc.intel.com> <20090820205425.GF13061@ldl.fc.hp.com> <20090820210342.GC29994@basil.fritz.box> <20090820212024.GG13061@ldl.fc.hp.com> <1250803577.2754.30.camel@sbs-t61.sc.intel.com> <4A8DC349.5060508@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8DC349.5060508@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I agree... if this ID is used for topology detection, we shouldn't
> replace it arbitrarily with information from BIOS just to hope that it
> matches the motherboard stencil.  *Furthermore*, there is no reason why
> motherboard stencilAs are purely numeric... consider the rather obvious
> case of two rows of four CPUs; they may have CPU slots labelled A1, A2,
> A3, A4, B1, B2, B3, B4.  It might very well be the right thing to
> support arbitrary strings for platforms we recognize.

Maintaining a manual mapping to strings in the kernel to such strings 
would be just crazy. You would need a new entry for basically
every system.

The reason to correct SOCKETID is that it it is output on errors.
If it is numerical and you know it's wrong you can correct it,
and then you can identify the right CPU. Otherwise you lose.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
