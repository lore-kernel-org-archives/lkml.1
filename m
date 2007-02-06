Return-Path: <linux-kernel-owner+w=401wt.eu-S965528AbXBFVlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965528AbXBFVlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933292AbXBFVlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:41:24 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:49346 "EHLO
	fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933252AbXBFVlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:41:23 -0500
Date: Tue, 6 Feb 2007 22:38:27 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: =?unknown-8bit?B?6Kix5oGG5ZiJ?= <edward_hsu@realtek.com.tw>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, hiwu@realtek.com.tw
Subject: Re: [PATCH 2.6.19.2] r8169: support RTL8169SC/8110SC
Message-ID: <20070206213827.GA25119@electric-eye.fr.zoreil.com>
References: <45C2F390.4070805@realtek.com.tw> <20070203003952.GA22823@electric-eye.fr.zoreil.com> <45C6A8EC.5090201@realtek.com.tw> <20070206003130.GA18236@electric-eye.fr.zoreil.com> <45C7EB8A.1090700@realtek.com.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45C7EB8A.1090700@realtek.com.tw>
User-Agent: Mutt/1.4.2.1i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

edward_hsu@realtek.com.tw :
[...]
> ANS_2:
> So, do you think that it is a good idea to keep other vendos's PID and
> DID in the part?

Yes.

[...]
> ANS_2:
> 
> Sure! You are right. RTL8110SC, RTL8111B and RTL8101E have modest
> differences, now. However, RTL8101E is a PCI-E fast ethernet controller.
> I don't think is a good idea to merge its Linux driver into r8168.c or
> r8169.c. RTL8110SC is the final version of Realtek PCI gigabit ethernet
> controller. Moreover, due to the increasing popularity of PCI-E, Realtek
> is going to design several generations of PCI-E ethernet controllers to
> satisfy customer requests. I have discussed this issue with my hardware
> colleagues. They believe that both MAC register layout and tx/rx
> descriptor layout will be changed a lot in new PCI-E ICs. Actually, they
> already did. Therefore, the hardwares of RTL8111B(PCI-E gigabit
> ethernet) and RTL8101E(PCI-E fast ethernet) will have frequent and
> drastic changes. So, I think that it's a good moment to separate their
> Linux drivers, and r8169.c can become stable.

Well, code and facts will tell. :o)

Since you asked for questions:

- will the ~7k limit for the jumbo frames be fixed ? One can hardly call
  it a feature.

- out of curiosity, did you try the current in-kernel r8169 driver with
  a 8111B or a 8101E ?

- is there any plan to open the programming manuals of the PCI-E chipsets ?

-- 
Ueimor
