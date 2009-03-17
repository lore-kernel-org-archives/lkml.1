Return-Path: <linux-kernel-owner+w=401wt.eu-S1755639AbZCQT7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639AbZCQT7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 15:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbZCQT7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 15:59:41 -0400
Received: from gw.goop.org ([64.81.55.164]:43759 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbZCQT7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 15:59:41 -0400
Message-ID: <49C0012A.6060903@goop.org>
Date: Tue, 17 Mar 2009 12:59:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com> <49BCA03D.3020605@goop.org> <20090315203802.GA14625@elte.hu> <49BD70EF.7010204@goop.org> <20090315212854.GA23960@elte.hu> <49BD8F15.4020301@goop.org> <20090316085402.GC1062@elte.hu> <49BE7A84.2030503@goop.org> <49BE84D6.3010006@kernel.org> <49BE9248.6050707@goop.org> <49BE97D5.4010002@zytor.com> <49BEA7BE.6050400@goop.org> <49BEAD27.3050801@kernel.org> <49BEAFEC.7020400@goop.org> <49BEB5FE.7050601@zytor.com> <49BEBD98.3090905@goop.org> <49BEC143.6030104@zytor.com> <49BEC53F.20200@goop.org> <49BED431.5070201@zytor.com> <49BF0A51.5000909@kernel.org> <49BF2054.9020009@zytor.com> <49BF301C.6010708@goop.org> <49BFCA05.7000508@zytor.com> <49BFFD3C.3020908@goop.org> <49BFFDE4.1070601@zytor.com>
In-Reply-To: <49BFFDE4.1070601@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>>
>> Here's an updated patch:
>>
>
> I already pushed an update (and you should have gotten notification 
> email)... 

Mail went to Citrix, which I don't check as regularly.

> can you verify that it matches what the end result should be in your 
> opinion?

Yep, looks good.

I've rebased the other two changes:

The following changes since commit 60ac98213914cc615c67e84bfb964aa95a080d13:
  H. Peter Anvin (1):
        x86-32: tighten the bound on additional memory to map

are available in the git repository at:

  ssh://master.kernel.org/~jeremy/git/xen.git tip/x86/setup-memory

Jeremy Fitzhardinge (2):
      x86/brk: make the brk reservation symbols inaccessible from C
      x86/brk: put the brk reservations in their own section

 arch/x86/include/asm/setup.h     |   10 +++++-----
 arch/x86/kernel/vmlinux_32.lds.S |    8 +++++---
 arch/x86/kernel/vmlinux_64.lds.S |    4 +++-
 3 files changed, 13 insertions(+), 9 deletions(-)


