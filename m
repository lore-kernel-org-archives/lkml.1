Return-Path: <linux-kernel-owner+w=401wt.eu-S1760924AbYGABGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760924AbYGABGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 21:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbYGABF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 21:05:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:3162 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747AbYGABF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 21:05:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,729,1204531200"; 
   d="scan'208";a="403827654"
Subject: Re: [PATCH 1/2] x86 boot: add E820_RESVD_KERN
From: "Huang, Ying" <ying.huang@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       andi@firstfloor.org, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <86802c440806301620hafa3ee3k8c5dbe6c45188d69@mail.gmail.com>
References: <86802c440806260247p19f5b850r8757c51280912ae9@mail.gmail.com>
	 <86802c440806271505n78275758re235ef6616d95b3d@mail.gmail.com>
	 <1214809434.2887.8.camel@caritas-dev.intel.com>
	 <86802c440806300034x5bb9b7a1s168bbeaee17e5124@mail.gmail.com>
	 <1214812303.3187.10.camel@caritas-dev.intel.com>
	 <86802c440806300215w31abbcb3h6a42395e11701713@mail.gmail.com>
	 <1214818706.23677.8.camel@caritas-dev.intel.com>
	 <86802c440806301205y35563326rd2ada495a0024441@mail.gmail.com>
	 <20080630191628.GA15366@elte.hu>
	 <86802c440806301553y240b020bh9dc448e8085fe60d@mail.gmail.com>
	 <86802c440806301620hafa3ee3k8c5dbe6c45188d69@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 01 Jul 2008 09:09:42 +0800
Message-Id: <1214874582.27760.0.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
X-OriginalArrivalTime: 01 Jul 2008 01:05:32.0612 (UTC) FILETIME=[8FAA3840:01C8DB16]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Yinghai,

On Mon, 2008-06-30 at 16:20 -0700, Yinghai Lu wrote:
> On Mon, Jun 30, 2008 at 3:53 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > On Mon, Jun 30, 2008 at 12:16 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >>
> >> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >>
> >>> > For find_e820_area, this is safe enough. But what about conflict
> >>> > between setup_data and ebda or ramdisk?
> >>>
> >>> can you have setup_data and ebda at the same time?
> >>>
> >>> setup_data and ramdisk should be ok, because bootloader is supposed to
> >>> make them not to be conflicts.
> >>
> >> the more sanity checks we do before relying on some crutial data, the
> >> better. It's easier to panic or sanitize data in some structured way and
> >> complain about it in the syslog than to let things get corrupted. Boot
> >> loaders are ... not unknown to be have bugs too, at times.
> >
> > to address Ying's concern, we could let reserve_setup_data
> > call reserve_early in addition to e820_update_range...
> >
> > reserve_early will panic if RAMDISK overlap efi setup_data...
> >
> 
> Ying,
> please check the attached patch

Which git-x86 head should I use to test the patch? It can not be applied
to x86/master.

Best Regards,
Huang Ying

