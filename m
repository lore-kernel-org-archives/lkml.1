Return-Path: <linux-kernel-owner+w=401wt.eu-S932455AbYGRBqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455AbYGRBqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 21:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759081AbYGRBq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 21:46:26 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:33402 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759066AbYGRBqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 21:46:25 -0400
Date: Thu, 17 Jul 2008 21:46:23 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Message-ID: <20080718014623.GA31111@bromo.msbb.uc.edu>
References: <20080717004004.GA17792@bromo.msbb.uc.edu> <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com> <20080717023538.GA18329@bromo.msbb.uc.edu> <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com> <20080717034418.GA18951@bromo.msbb.uc.edu> <86802c440807162113g4cea3bd9ic71210330417032b@mail.gmail.com> <20080717061825.GA19582@bromo.msbb.uc.edu> <86802c440807162348m6d05b912x7b3f655d7f9efb93@mail.gmail.com> <20080718011532.GA30920@bromo.msbb.uc.edu> <86802c440807171825m24ffe140o81bb76286823568e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807171825m24ffe140o81bb76286823568e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YH,
  I did some googling and it looks like the dmicode should
be MacBookPro2...

http://www.odi.ch/prog/macbookpro/dmi.txt

Building a test kernel with that code in the mmconfig patch now.
                        Jack

On Thu, Jul 17, 2008 at 06:25:43PM -0700, Yinghai Lu wrote:
> On Thu, Jul 17, 2008 at 6:15 PM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> > YH,
> >   Success. It turns out that if I unset CONFIG_PCIEASPM when
> > I build 2.6.26 the hangs on boot are eliminated.
> 
> good to know
> 
> > I am currently
> > booted under the current fedora development 2.6.27-0.156.rc0.git4
> > with that change and everything is working fine.
> >   I've not had any luck with pci_early_config_dump. If I just pass
> > that kernel option, it doesn't complain but it doesn't seem to
> > produce any additional output in dmesg. Do I need any other kernel
> > options for pci_early_config_dump to work?
> shoud be pci=early_config_dump
> 
> > I will apply your mmconfig
> > patch next and test how well MMCONFIG works on my MacBook Pro.
> 
> also please send out dmidecode printout, so i could update patch to
> apply dmi quirk to that model only.
> 
> YH
