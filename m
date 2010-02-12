Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab0BLKJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 05:09:29 -0500
Received: from mail.bitdefender.com ([91.199.104.2]:50808 "EHLO
	mail.bitdefender.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab0BLKJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 05:09:27 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Feb 2010 05:09:26 EST
From: Mihai =?utf-8?q?Don=C8=9Bu?= <mihai.dontu@gmail.com>
Organization: Home
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH] Add an Apple iMac9,1 DMI entry to reboot.c so the machine reboot's properly.
Date: Fri, 12 Feb 2010 12:02:43 +0200
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
References: <1265484976-13414-1-git-send-email-justinmattock@gmail.com> <4B717980.2030802@gmail.com> <4B751C1A.5020404@gmail.com>
In-Reply-To: <4B751C1A.5020404@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201002121202.44822.mihai.dontu@gmail.com>
X-BitDefender-Spam: No (0)
X-BitDefender-SpamStamp: v1, build 2.8.84.85629, bayes score: 500(0),
 pbayes score: 241(0), neunet score: 0(0), flags:
 [NN_S_ENDS_IN_FULLSTOP_BGU; NN_VALID_REPLY;
 NN_LEGIT_SQARE_BRACKETS_SUBJ], SQMD:
 55ff9da7d25736148733fa1581feb253.fuzzy.fzrbl.org, total: 0(775)
X-BitDefender-Scanner: Clean, Agent: BitDefender qmail 3.1.0 on
 elfie.dsd.hq, sigver: 7.30341
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 February 2010 11:15:06 Justin P. Mattock wrote:
> On 02/09/10 07:04, Justin P. Mattock wrote:
> > Whats the status if this patch?
> > 
> > > On the iMac9,1 sudo /sbin/reboot results in
> > > a black screen. Adding this DMI entry gets the
> > > machine to reboot cleanly as it should.
> > > 
> > > 
> > > Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
> > > ---
> > > arch/x86/kernel/reboot.c | 8 ++++++++
> > > 1 files changed, 8 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> > > index 704bddc..2de6645 100644
> > > --- a/arch/x86/kernel/reboot.c
> > > +++ b/arch/x86/kernel/reboot.c
> > > @@ -461,6 +461,14 @@ static struct dmi_system_id __initdata
> > > pci_reboot_dmi_table[] = {
> > > DMI_MATCH(DMI_PRODUCT_NAME, "Macmini3,1"),
> > > },
> > > },
> > > + { /* Handle problems with rebooting on Apple iMac9,1 */
> > > + .callback = set_pci_reboot,
> > > + .ident = "Apple iMac9,1",
> > > + .matches = {
> > > + DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
> > > + DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
> > > + },
> > > + },
> > > { }
> > > };
> 
> so what do I have todo file a bugreport against this
> to get a response from you people?

Looking at Linus' git tree, it would seem that Ingo Molnar is the "entry 
point" for the patches in arch/x86/kernel/reboot.c. Maybe you should try CC-
ing him?

-- 
Mihai Donțu
