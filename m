Return-Path: <linux-kernel-owner+w=401wt.eu-S1758300AbYGQMrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300AbYGQMrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 08:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbYGQMri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 08:47:38 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:39865 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751461AbYGQMri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 08:47:38 -0400
Date: Thu, 17 Jul 2008 08:47:36 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Message-ID: <20080717124736.GA23280@bromo.msbb.uc.edu>
References: <86802c440807161029n7e0dac98x1ec260879204b6f0@mail.gmail.com> <86802c440807161535n3a4d6891n6f7c16bd4e1f19c3@mail.gmail.com> <20080717004004.GA17792@bromo.msbb.uc.edu> <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com> <20080717023538.GA18329@bromo.msbb.uc.edu> <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com> <20080717034418.GA18951@bromo.msbb.uc.edu> <86802c440807162113g4cea3bd9ic71210330417032b@mail.gmail.com> <20080717061825.GA19582@bromo.msbb.uc.edu> <86802c440807162348m6d05b912x7b3f655d7f9efb93@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807162348m6d05b912x7b3f655d7f9efb93@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YH,
   A kernel built with CONFIG_PCIEASPM_DEBUG=y and
booted with 'debug initcall_debug apic=verbose pci=routeirq'
doesn't show any additional messages on booting. Do I need
any addition flags? I would note that the hang in 2.6.26 always
appears to occur before the line...

PCI: Transparent bridge - 0000:00:1e.0

ever appears. It hangs just after the two preceeding lines
which always appear in dmesg on 2.6.25.10 and 2.6.26...

pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO

         Jack


On Wed, Jul 16, 2008 at 11:48:19PM -0700, Yinghai Lu wrote:
> >
> should get
> PCI: Fixups for bus 0000:01
> PCI: Transparent bridge - 0000:00:01.0
> PCI: bridge 0000:00:01.0 io port: [3000, 3fff]
> PCI: bridge 0000:00:01.0 32bit mmio: ...
> PCI: Bus scan for 0000:01 returning with max=01
> 
> Do you have CONFIG_PCIEASPM in your config?
> 
> YH
