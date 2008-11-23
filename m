Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbYKWXnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbYKWXnX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 18:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbYKWXnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 18:43:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42185 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbYKWXnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 18:43:14 -0500
Date: Mon, 24 Nov 2008 00:42:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Dmitry Nezhevenko <dion@inhex.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.28 git: WARNING: at arch/x86/kernel/cpu/mtrr/generic.c:404
	generic_get_mtrr+0xea/0x120()
Message-ID: <20081123234252.GA27750@elte.hu>
References: <20081120092239.GA16613@laptop.local> <200811222144.31812.rjw@sisk.pl> <86802c440811221343n61b9d20cue4d89c1c4b45121c@mail.gmail.com> <20081123095708.GA7502@laptop.local> <86802c440811231541i4bee7589j9de44b91dddf195a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440811231541i4bee7589j9de44b91dddf195a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Sun, Nov 23, 2008 at 1:57 AM, Dmitry Nezhevenko <dion@inhex.net> wrote:
> > On Sat, Nov 22, 2008 at 01:43:25PM -0800, Yinghai Lu wrote:
> >>
> >> can we get whole boot message? also cat /proc/mtrr
> >>
> >> YH
> >
> > dmesg: http://inhex.net/dion/tmp/dmesg-2.6.28-rc5.txt
> >
> > /proc/mtrr:
> > reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> > reg04: base=0x0000f8000 (    0MB), size=   32KB, count=1: write-protect
> > reg05: base=0x0000dc000 (    0MB), size=    8KB, count=1: write-back
> 
> so that patch workaround your BIOS setup with mtrr  mask setting.

so the kernel was right to issue a warning.

	Ingo
