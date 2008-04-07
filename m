Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbYDGFsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbYDGFsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 01:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYDGFsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 01:48:11 -0400
Received: from nn7.de ([85.214.94.156]:36900 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbYDGFsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 01:48:10 -0400
Subject: RE: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n-Apple
From: Soeren Sonnenburg <kernel@nn7.de>
To: "Pallipadi\, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Carlos R\. Mafra" <crmafra2@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       "Rafael J\. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEED0F279@orsmsx423.amr.corp.intel.com>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
	 <pdYe6zNQVl.A.AOB.6GW9HB@albercik>
	 <924EFEDD5F540B4284297C4DC59F3DEED0EA1E@orsmsx423.amr.corp.intel.com>
	 <20080404011053.GA21254@localhost.ift.unesp.br>
	 <2c0942db0804032015y57e91811r37b729cd836cef6d@mail.gmail.com>
	 <20080404114756.GA3890@localhost.ift.unesp.br>
	 <924EFEDD5F540B4284297C4DC59F3DEED0EB77@orsmsx423.amr.corp.intel.com>
	 <20080404155155.GA6578@localhost.ift.unesp.br>
	 <924EFEDD5F540B4284297C4DC59F3DEED0EEC6@orsmsx423.amr.corp.intel.com>
	 <20080406205610.GA4647@localhost.ift.unesp.br>
	 <924EFEDD5F540B4284297C4DC59F3DEED0F279@orsmsx423.amr.corp.intel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 07 Apr 2008 07:48:05 +0200
Message-Id: <1207547285.5962.49.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-04-06 at 22:31 -0700, Pallipadi, Venkatesh wrote:
[...]
> >I applied Venkatesh's patch from the link above on top of 
> >v2.6.25-rc8-139-ge315c12, but my laptop hung at the 11th boot with the
> >same state show here:
> >http://www.ift.unesp.br/users/crmafra/dsc04673.jpg
> >
> >I waited 3'30" but the boot process never resumed, so I pressed
> >the power button.
> >
> >Any further patches I might try?
> 
> Carlos,
> 
> Hmm. So, we still have some bug hidden in there..
> As this is similar to 10117, we should probably track this there.
> 10093 is a different cpuidle specific bug looks like, as it happens at a
> different place while switching between governors.
> 
> Can you attach your kernel config, acpidump output and dmesg when kernel
> boots ok to that bugzilla.

you could use what I've send as I was seeing this bug too... but maybe
his config (sony vaio?) is well directly point to the problem.

[...]
> One more qn. Did you see this problem witj 2.6.24 as well or is this
> something that you started seeing only recently?

This thing I can answer: yes this is new in 2.6.25 and in there since at
least 23 Feb 2008.

Soeren

