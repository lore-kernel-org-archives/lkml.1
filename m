Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbYGQCfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbYGQCfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 22:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbYGQCfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 22:35:41 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:36267 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753900AbYGQCfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 22:35:41 -0400
Date: Wed, 16 Jul 2008 22:35:38 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Message-ID: <20080717023538.GA18329@bromo.msbb.uc.edu>
References: <20080716035830.GA27935@bromo.msbb.uc.edu> <dd18b0c30807152230u39ef9c18v78b48d1c7b9ddd17@mail.gmail.com> <86802c440807160044ge504cacl419b6cbcad5f0f9d@mail.gmail.com> <dd18b0c30807160050r5b10908fiffc2a4b464abe5f3@mail.gmail.com> <86802c440807160136m6af981b2u6a37cabb8e33a629@mail.gmail.com> <20080716140810.GA2861@bromo.msbb.uc.edu> <86802c440807161029n7e0dac98x1ec260879204b6f0@mail.gmail.com> <86802c440807161535n3a4d6891n6f7c16bd4e1f19c3@mail.gmail.com> <20080717004004.GA17792@bromo.msbb.uc.edu> <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai,
   As I expected pci=mmconf doesn't allow the MacBook Pro to boot.
My understanding is that mmconfig is need for Linux on Macintel
(at least for a shared MacOS X/Linux system).
   I am stuck with regards to the pci_early_config_dump results.
The output we need scrolls off the top of the screen and since
the boot hangs I can't access with dmesg. Can you suggest a hack
right at the end of the code that does pci_early_config_dump that
would halt the boot immediately after the pci_early_config_dump?
Unfortunately, 2.6.25.10 doesn't appear to support that feature
(it doesn't seem to produce any difference in the output here).
                        Jack
