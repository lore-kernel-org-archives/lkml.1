Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbYLNXZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbYLNXZV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 18:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751696AbYLNXZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 18:25:09 -0500
Received: from smtp2.ono.com ([62.42.230.20]:31397 "EHLO resmaa12.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751524AbYLNXZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 18:25:08 -0500
Date: Mon, 15 Dec 2008 00:24:21 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Bugs on aspire one A150
Message-ID: <20081215002421.5b9a607c@werewolf.home>
In-Reply-To: <1229296708.12025.2.camel@maxim-laptop>
References: <491506DB.1070000@gmail.com>
	<1229174138.24940.9.camel@maxim-laptop>
	<20081214235753.7cd11c51@werewolf.home>
	<1229296708.12025.2.camel@maxim-laptop>
X-Mailer: Claws Mail 3.6.1cvs75 (GTK+ 2.14.5; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2008 01:18:28 +0200, Maxim Levitsky <maximlevitsky@gmail.com> wrote:

> On Sun, 2008-12-14 at 23:57 +0100, J.A. Magallón wrote:
> > On Sat, 13 Dec 2008 15:15:38 +0200, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > 
> > > 
> > > I also noticed, that now the SD only card reader is always enabled
> > > regardless of card been there while booting, and same happens in
> > > windows, I suspect that this is permanent hardware change, which worries
> > > me, but this reader works fine otherwise.
> > > (This is another reason why binary bioses are evil, go and find out why
> > > it enables it)
> > > 
> > 
> > Which BIOS ? Mine is 3304, kernel is 2.6.28-rc8, and LEFT card is not detected
> > unless I use this option:
> > 
> > options sdhci debug_quirks=1
> > 
> v0.3301
> 
> left read was and does work fine, but before some time it wasn't present
> on boot, if there were no card in it, but was hotplugged using acpiphp
> when I put it there, but now it is present regardless of card, and I did
> no changes in system, so it must be a hardware malfunction/bug.
> 

But how do you load acpiphp ? I try and I just get:

one:/etc# modprobe acpiphp debug=1
FATAL: Error inserting acpiphp (/lib/modules/2.6.28-desktop-0.rc8.1mnb/kernel/drivers/pci/hotplug/acpiphp.ko.gz): No such device

from syslog:

acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
acpiphp_glue: Total 0 slots

??

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.1 (Cooker) for x86_64
Linux 2.6.27.5-desktop-1mnb (gcc 4.3.2 (GCC) #1 Sun Nov
