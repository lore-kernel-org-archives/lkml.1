Return-Path: <linux-kernel-owner+w=401wt.eu-S1760105AbYGQDo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105AbYGQDo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 23:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYGQDoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 23:44:21 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:45461 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752654AbYGQDoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 23:44:21 -0400
Date: Wed, 16 Jul 2008 23:44:18 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Message-ID: <20080717034418.GA18951@bromo.msbb.uc.edu>
References: <86802c440807160044ge504cacl419b6cbcad5f0f9d@mail.gmail.com> <dd18b0c30807160050r5b10908fiffc2a4b464abe5f3@mail.gmail.com> <86802c440807160136m6af981b2u6a37cabb8e33a629@mail.gmail.com> <20080716140810.GA2861@bromo.msbb.uc.edu> <86802c440807161029n7e0dac98x1ec260879204b6f0@mail.gmail.com> <86802c440807161535n3a4d6891n6f7c16bd4e1f19c3@mail.gmail.com> <20080717004004.GA17792@bromo.msbb.uc.edu> <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com> <20080717023538.GA18329@bromo.msbb.uc.edu> <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YH,
   Okay, I can confirm that 2.6.25.10 boots okay with pci=nommconf
which does disable MMCONFIG. It also works fine by default with
MMCONFIG enabled. So there may be two possibly unrelated problems
in 2.6.26. The first being that MMCONFIG doesn't start up properly
without your patch and the second being that with or without
MMCONFIG, the boot process hangs just before when the line...

PCI: Transparent bridge - 0000:00:1e.0

should appear.
                         Jack
