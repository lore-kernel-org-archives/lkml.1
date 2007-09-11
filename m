Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbXIKOcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbXIKOcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 10:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbXIKOcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 10:32:45 -0400
Received: from smtp2a.orange.fr ([80.12.242.139]:33527 "EHLO smtp2a.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbXIKOco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 10:32:44 -0400
X-ME-UUID: 20070911143242514.7DA6C700008A@mwinf2a14.orange.fr
Subject: Re: r8169: instant reboot and interface renaming
From: Xavier Bestel <xavier.bestel@free.fr>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070911153229.2dc8cc03@laptopd505.fenrus.org>
References: <1189514631.20015.108.camel@frg-rhel40-em64t-04>
	 <20070911153229.2dc8cc03@laptopd505.fenrus.org>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 16:32:39 +0200
Message-Id: <1189521159.20015.114.camel@frg-rhel40-em64t-04>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 15:32 +0100, Arjan van de Ven wrote:
> this is userspace doing "eth name by MAC address", your new card has a
> different MAC address than your old card, the userspace application
> tries to bind each name uniquely to an ethX name so it keeps eth0 free
> for your old card.
> 
> If you have a RH/Fedora like distribution, you can hack out the mac
> address from the /etc/sysconfig/network-scripts/ifcfg-eth0 file

Thanks, that was it. For those who are interested, under debian
it's /etc/udev/rules.d/z25_persistent-net.rules

> > The other problem I have is, as soon as I do
> > ifconfig eth3 up
> > the machine is rebooting (like if I pressed the reset button).
> > Adding "acpi=noirq" to the boot cmdline seems to solve this, but
> > I wonder if it's the proper
> > solution ?
> 
> it's obviously not the proper solution :)
> it's odd though; it could entirely be a bios bug. you may want to file
> a bug at bugzilla.kernel.org against the acpi component, and make sure
> you include the full dmesg of a boot at least...

OK, filed http://bugzilla.kernel.org/show_bug.cgi?id=9007

Thanks,
	Xav


