Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbYIBUze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbYIBUze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 16:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYIBUz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 16:55:27 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:38715 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbYIBUz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 16:55:26 -0400
Date: Tue, 2 Sep 2008 17:55:44 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: herton@mandriva.com.br, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
Message-ID: <20080902175544.131bc54e@doriath.conectiva>
In-Reply-To: <alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de>
References: <20080902163532.436f8fbd@doriath.conectiva>
	<alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 2 Sep 2008 22:18:25 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> escreveu:

| On Tue, 2 Sep 2008, Luiz Fernando N. Capitulino wrote:
| > 
| >  I have a HP Pavilion dv6000 laptop here which doesn't boot with
| > latest Linus tree (2.6.27-rc5).
| > 
| >  The last lines I see on the screen are:
| > 
| > """
| > hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
| > hpet0: 3 32-bit timers, 25 000000 Hz
| > """
| 
| Sigh. I'm getting sick of that :)

 I can imagine... Will do my best to help, but I don't know anything
about hpet. :(

| >  I would try to revert it from current Linus' tree to see if it
| > really fix the problem but turns out that it will take some time
| > to work on the conflicts.
| 
| Don't do that. We really need to find out what the root cause of this
| HPET wreckage on those AMD machine is. The commit in question _IS_ the
| alleged culprit, but the root cause is something different.

 Okay, and thanks for the others explanations.

| >  I'm attaching the 2.6.26.3 (Mandriva kernel) and 2.6.27-rc5 (with
| > hpet=disable) dmesg files.
| > 
| >  Also, this _seems_ to be the same as reported in:
| > 
| > http://bugzilla.kernel.org/show_bug.cgi?id=11191
| 
| Yup.
|  
| >  But I'm still compiling the kernel with the appropriate config
| > options to confirm this.
| > 
| >  Please, let me know if there's anything else I can do to
| > help you debug this.
| 
| Can you please disable CONFIG_HPET ?

 It still hangs but at a different point, the last two messages are:

"""
PCI: Using ACPI for IRQ routing
DMAR:parse DMAR table failure.
"""

 Also, after about 10 minutes I get the same backtrace as reported in
the ticket above... It's the same bug then.

-- 
Luiz Fernando N. Capitulino
