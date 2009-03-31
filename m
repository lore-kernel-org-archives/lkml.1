Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbZCaU1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbZCaU1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 16:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbZCaU10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 16:27:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44957 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbZCaU1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 16:27:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [Updated patch] Re: [PATCH] igb: fix kexec with igb
Date: Tue, 31 Mar 2009 22:27:12 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-rjw; KDE/4.2.1; x86_64; ; )
Cc: "Tantilov, Emil S" <emil.s.tantilov@intel.com>,
       Yinghai Lu <yinghai@kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>
References: <49B1F934.5050006@kernel.org> <EA929A9653AAE14F841771FB1DE5A1365F71995716@rrsmsx501.amr.corp.intel.com> <9929d2390903311251n43988214y6f1b2defa87e1a48@mail.gmail.com>
In-Reply-To: <9929d2390903311251n43988214y6f1b2defa87e1a48@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903312227.13788.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009, Jeff Kirsher wrote:
> On Tue, Mar 31, 2009 at 12:14 PM, Tantilov, Emil S
> <emil.s.tantilov@intel.com> wrote:
> >
> > The patch checks out. I tested suspend/resume (including WOL) and kexec. There is only a small issue with warning on compile when CONFIG_PM is disabled:
> >
> > diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
> > index 13fe162..0a4f8f4 100644
> > --- a/drivers/net/igb/igb_main.c
> > +++ b/drivers/net/igb/igb_main.c
> > @@ -135,8 +135,8 @@ static inline int igb_set_vf_rlpml(struct igb_adapter *, int, int);
> >  static int igb_set_vf_mac(struct igb_adapter *adapter, int, unsigned char *);
> >  static void igb_restore_vf_multicasts(struct igb_adapter *adapter);
> >
> > -static int igb_suspend(struct pci_dev *, pm_message_t);
> >  #ifdef CONFIG_PM
> > +static int igb_suspend(struct pci_dev *, pm_message_t);
> >  static int igb_resume(struct pci_dev *);
> >  #endif
> >  static void igb_shutdown(struct pci_dev *);
> >
> > Thanks,
> > Emil
> >
> 
> Rafael - Based on Emil's testing, I will modify the patch with Emil's
> suggestion and push to Dave, ok?

Fine with me.

Thanks,
Rafael
