Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbZKWTHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbZKWTHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbZKWTHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:07:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752957AbZKWTHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 14:07:10 -0500
Date: Mon, 23 Nov 2009 17:05:57 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>, kvm <kvm@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: kvm hangs w/o nolapic
Message-ID: <20091123190557.GA11359@amt.cnet>
References: <1258715515.7094.51.camel@johannes.local> <20091120181815.GA8779@lenovo> <1258752341.7094.79.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258752341.7094.79.camel@johannes.local>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 10:25:41PM +0100, Johannes Berg wrote:
> On Fri, 2009-11-20 at 21:18 +0300, Cyrill Gorcunov wrote:
> 
> > I've just booted a latest -tip with kvm without problems.
> 
> Unfortunately, -tip is usually different enough that I it tends to not
> matter to me while I'm running a mainline kernel :)
> 
> > I've been using
> > 
> > |
> > | QEMU PC emulator version 0.9.1 (kvm-84)
> 
> QEMU PC emulator version 0.10.50 (qemu-kvm-devel-88), Copyright (c)
> 2003-2008 Fabrice Bellard

Johaness,

Can you please try git://git.kernel.org/pub/scm/virt/kvm/qemu-kvm.git ?

There have been a number of HPET emulation fixes.

