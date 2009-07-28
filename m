Return-Path: <linux-kernel-owner+w=401wt.eu-S1752316AbZG1QyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbZG1QyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZG1QyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:54:21 -0400
Received: from os.eurotux.com ([216.75.63.6]:35641 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbZG1QyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:54:20 -0400
Date: Tue, 28 Jul 2009 17:54:16 +0100
From: Luciano Rocha <luciano@eurotux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       corentincj@iksaif.net
Subject: Re: eeepc_hotkey adds 25s to boot
Message-ID: <20090728165416.GI11494@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <luciano@eurotux.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
	corentincj@iksaif.net
References: <20090727192720.GA30366@bit.office.eurotux.com>
 <84144f020907271245q1d635e49j15a32c85303bf073@mail.gmail.com>
 <20090728165026.GH11494@bit.office.eurotux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090728165026.GH11494@bit.office.eurotux.com>
User-Agent: Mutt/1.5.20 (2009-07-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 05:50:26PM +0100, Luciano Rocha wrote:
> On Mon, Jul 27, 2009 at 10:45:14PM +0300, Pekka Enberg wrote:
> > (Adding Corentin to cc)
> > 
> > On Mon, Jul 27, 2009 at 10:27 PM, Luciano Rocha<luciano@eurotux.com> wrote:
> > > As subject says, loading the eeepc_hotkeys driver or including it inside
> > > the kernel adds 25s to the boot process:
> > > [   13.990092] eeepc: Eee PC Hotkey Driver
> > > [   39.560645] eeepc: Hotkey init flags 0x41
> > > [   39.566131] eeepc: Get control methods supported: 0x101713
> > > [   39.566418] input: Asus EeePC extra buttons as ...
> > >
> > > Kernel is 2.6.30.3 (with tuxonice).
> > >
> > > Config and full dmesg follows.
> > >
> > > Also, a "rmmod eeepc_hotkeys" resulted in a kernel panic. If asked, I'll
> > > try to replicate it.
> > 
> > Yes, please.
> 
> Hm, rebooted without i2c_i801, browsed some, then did a rmmod
> eeepc_laptop:
> ERROR!!! H2M_MAILBOX still hold by MCU. command fail
> ERROR!!! H2M_MAILBOX still hold by MCU. command fail
> 
> Two equal lines, yes. What does it mean?

Nevermind, the wireless driver didn't like that the hardware
disappeared.

-- 
Luciano Rocha <luciano@eurotux.com>
Eurotux Informática, S.A. <http://www.eurotux.com/>
