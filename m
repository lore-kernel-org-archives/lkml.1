Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbYEWNRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbYEWNRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbYEWNRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:17:16 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:39452 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752241AbYEWNRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:17:15 -0400
Message-ID: <411548657.14585@ustc.edu.cn>
X-WebMAIL-MUA: [211.86.158.77]
From: "JiSheng Zhang" <jszhang3@mail.ustc.edu.cn>
To: stefanr@s5r6.in-berlin.de
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       krh@redhat.com
Date: Fri, 23 May 2008 21:17:37 +0800
Reply-To: "JiSheng Zhang" <jszhang3@mail.ustc.edu.cn>
X-Priority: 3
Subject: Re: [PATCH] firewire: fix some broken hardware NMI interrupt
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
after a lot of test today, the problem appears again. Now it also emit a similar
message even applied my patch. Tested on 2.6.25-4 and 2.6.26-rc3.
The via chip is VT6306. How can I dig into this problem more?

CU,
JiSheng

>From: Stefan Richter <stefanr@s5r6.in-berlin.de>
>Reply-To: 
>To: JiSheng Zhang <jszhang3@mail.ustc.edu.cn>
>Subject: Re: [PATCH] firewire: fix some broken hardware NMI interrupt
>Date:Thu, 22 May 2008 15:38:30 +0200
>
>JiSheng Zhang wrote:
> >> From: Stefan Richter <stefanr@s5r6.in-berlin.de>
> >> jszhang3@mail.ustc.edu.cn wrote:
> >>> Some broken pci-1394 card does not clear completely on-chip memory during
> >>> boot, it
> >>> may cause pci parity error, then NMI interrupt.
> >> 
> >> Which card?
> > hmm, one card using VIA chip.
> >> 
> >> Is the problem still present in linux-2.6.26-rc3?
> > It seems that the problem disappeared. Thanks
> 
> Great, thanks for testing.
> 
> I hope this is now permanently fixed.  Should it ever appear again, just
> tell us.
> -- 
> Stefan Richter
> -=====-==--- -=-= =-==-
>


