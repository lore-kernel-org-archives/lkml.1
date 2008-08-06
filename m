Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbYHFNwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbYHFNwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 09:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbYHFNwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 09:52:22 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:39715 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753971AbYHFNwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 09:52:21 -0400
X-BigFish: VPS-37(zz1432R98dR4015M1805M936fQzz10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K56MIS-02-REY-01
Date: Wed, 6 Aug 2008 15:51:14 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Rene Herman <rene.herman@keyaccess.nl>
CC: Dave Airlie <airlied@gmail.com>, Shaohua Li <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, dri-users@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: AGP and PAT (induced?) problem (on AMD family 6)
Message-ID: <20080806135114.GB6713@alberich.amd.com>
References: <48972EA8.8040001@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <48972EA8.8040001@keyaccess.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 Aug 2008 13:51:18.0901 (UTC) FILETIME=[80A88A50:01C8F7CB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 06:30:32PM +0200, Rene Herman wrote:
> What _does_ solve this though is booting with the "nopat" command line 
> parameter. I'm on 2.6.26.1 and have enabled PAT for my AMD Duron myself. 
> With "nopat", there's no problem to be seen anymore -- exiting X 
> specifically is instantaneous.
>
> With or without PAT, my /proc/mtrr is always:
>
> reg00: base=0x00000000 (   0MB), size= 512MB: write-back, count=1
> reg01: base=0x20000000 ( 512MB), size= 256MB: write-back, count=1
> reg02: base=0xe8000000 (3712MB), size=  64MB: write-combining, count=1
>
> under X joined by:
>
> reg03: base=0xe4000000 (3648MB), size=  32MB: write-combining, count=2

To get some more debug data, can you please retest with latest kernel
(2.6.27-rc2) using "debugpat" kernel option and provide dmesg
output plus contents of <debugfs>/x86/pat_memtype_list?


Thanks,

Andreas


