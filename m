Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404AbYKXGA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbYKXGA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 01:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750909AbYKXGAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 01:00:13 -0500
Received: from inhex.net ([193.33.178.145]:39917 "EHLO inhex.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbYKXGAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 01:00:12 -0500
Date: Mon, 24 Nov 2008 07:59:59 +0200
From: Dmitry Nezhevenko <dion@inhex.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.28 git: WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:404
	generic_get_mtrr+0xea/0x120()
Message-ID: <20081124055959.GA15544@laptop.local>
References: <20081120092239.GA16613@laptop.local> <200811222144.31812.rjw@sisk.pl> <86802c440811221343n61b9d20cue4d89c1c4b45121c@mail.gmail.com> <20081123095708.GA7502@laptop.local> <86802c440811231541i4bee7589j9de44b91dddf195a@mail.gmail.com> <20081123234252.GA27750@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123234252.GA27750@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2008 at 12:42:52AM +0100, Ingo Molnar wrote:
 > >
> > > /proc/mtrr:
> > > reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> > > reg04: base=0x0000f8000 (    0MB), size=   32KB, count=1: write-protect
> > > reg05: base=0x0000dc000 (    0MB), size=    8KB, count=1: write-back
> > 
> > so that patch workaround your BIOS setup with mtrr  mask setting.
> 
> so the kernel was right to issue a warning.

Ok. Thanks.

Btw.. Should it really be a warning, that taints kernel? As I said,
2.6.27 has same message, however it's just printk().
 
-- 
WBR, Dmitry
