Return-Path: <linux-kernel-owner+w=401wt.eu-S1760640AbXHBWrH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760640AbXHBWrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 18:47:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbXHBWqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 18:46:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:65479 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427AbXHBWqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 18:46:55 -0400
Subject: Re: VIA EPIA EK: strange eth dev numbering
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       Herbert Rosmanith <kernel@wildsau.enemy.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708030039300.495@fbirervta.pbzchgretzou.qr>
References: <200708021056.l72Au722008603@wildsau.enemy.org>
	 <Pine.LNX.4.64.0708021347270.24572@fbirervta.pbzchgretzou.qr>
	 <46B1D708.9040106@msgid.tls.msk.ru>
	 <Pine.LNX.4.64.0708021536350.24572@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0708022034190.9319@fbirervta.pbzchgretzou.qr>
	 <3ae72650708021500v3de84e6vdf15d0a9e5baf661@mail.gmail.com>
	 <Pine.LNX.4.64.0708030039300.495@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Fri, 03 Aug 2007 00:49:39 +0200
Message-Id: <1186094979.3443.35.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.5 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19GyTv6oIzgq8UxVkBn5STKgYSeJUcYWDUpqbr
 x5kAQ/XLwmT66IiiA9SnyWve7yF/yor6yiZg8ftPXBJtWLR1DU
 kyUukoiKnElQmFuXOFhQ2LZleqoQaJj
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-08-03 at 00:39 +0200, Jan Engelhardt wrote:
> On Aug 3 2007 00:00, Kay Sievers wrote:
> >On 8/2/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> >> I know I have seen my kernel outputting "A renamed to B". Since you two
> >> however wanted that information in the first place, I grepped a bit
> >> around, and actually found, (drumroll), that the SUSE kernel has had a
> >> proper patch for [I can't remember how long] quite some time. (At least
> >> one distro which does the right thing.) I copied it below.
> >
> >> e1000: eth3: e1000_probe: Intel(R) PRO/1000 Network Connection
> >> dev_change_name: about to rename 'eth3' to 'eth0'
> >> dev_change_name: about to rename 'eth3' to 'ethxx3'
> >> eth3 renamed to ethxx3
> >
> >I just made udev when it successfully renamed an interface to write
> >that to the kernel log, so dmesg will show:
> >  <6>udev: renamed network interface eth0 to eth1
> 
> I think it is helpful to integrate the suse patch rather than to patch udev
> alone. This way, renames that do not involve udev also show up.

But if you need to swap interface names, you will see the useless
temporary device names. On SUSE, nothing else renames network interfaces
these days, so we'll probably just remove that patch. :)

Kay

