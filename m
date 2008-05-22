Return-Path: <linux-kernel-owner+w=401wt.eu-S933146AbYEVMGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146AbYEVMGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 08:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757682AbYEVMGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 08:06:42 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:55566 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1757405AbYEVMGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 08:06:42 -0400
Message-ID: <411458028.04591@ustc.edu.cn>
X-WebMAIL-MUA: [211.86.158.44]
From: "JiSheng Zhang" <jszhang3@mail.ustc.edu.cn>
To: stefanr@s5r6.in-berlin.de
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       krh@redhat.com
Date: Thu, 22 May 2008 20:07:08 +0800
Reply-To: "JiSheng Zhang" <jszhang3@mail.ustc.edu.cn>
X-Priority: 3
Subject: Re: [PATCH] firewire: fix some broken hardware NMI interrupt
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


>From: Stefan Richter <stefanr@s5r6.in-berlin.de>
>Reply-To: 
>To: jszhang3@mail.ustc.edu.cn
>Subject: Re: [PATCH] firewire: fix some broken hardware NMI interrupt
>Date:Wed, 21 May 2008 17:28:25 +0200
>
>jszhang3@mail.ustc.edu.cn wrote:
> > Some broken pci-1394 card does not clear completely on-chip memory during
boot, it
> > may cause pci parity error, then NMI interrupt.
> 
> Which card?
hmm, one card using VIA chip.
> 
> Is the problem still present in linux-2.6.26-rc3?
It seems that the problem disappeared. Thanks
> 
> Or if you don't want to test 2.6.26-rc yet, please test 2.6.25.4 with
> the firewire patchkit from
> http://me.in-berlin.de/~s5r6/linux1394/updates/.  There were changes to
> fw-ohci which influence chip initialization.
> -- 
> Stefan Richter
> -=====-==--- -=-= =-=-=
> http://arcgraph.de/sr/
>


