Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbYICQii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbYICQii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 12:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbYICQib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 12:38:31 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:57926 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbYICQia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 12:38:30 -0400
Date: Wed, 3 Sep 2008 13:38:48 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: herton@mandriva.com.br,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
Message-ID: <20080903133848.66f5c96e@doriath.conectiva>
In-Reply-To: <alpine.LFD.1.10.0809031635260.3243@apollo.tec.linutronix.de>
References: <20080902163532.436f8fbd@doriath.conectiva>
	<alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de>
	<20080902175544.131bc54e@doriath.conectiva>
	<alpine.LFD.1.10.0809031202290.3243@apollo.tec.linutronix.de>
	<20080903104132.7a736282@doriath.conectiva>
	<alpine.LFD.1.10.0809031635260.3243@apollo.tec.linutronix.de>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 3 Sep 2008 16:36:32 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> escreveu:

| On Wed, 3 Sep 2008, Luiz Fernando N. Capitulino wrote:
| 
| > Em Wed, 3 Sep 2008 12:04:58 +0200 (CEST)
| > Thomas Gleixner <tglx@linutronix.de> escreveu:
| > 
| > | On Tue, 2 Sep 2008, Luiz Fernando N. Capitulino wrote:
| > | > """
| > | > PCI: Using ACPI for IRQ routing
| > | > DMAR:parse DMAR table failure.
| > | > """
| > | > 
| > | >  Also, after about 10 minutes I get the same backtrace as reported in
| > | > the ticket above... It's the same bug then.
| > | 
| > | Venki found a nasty bug in the clock events code which might be
| > | related to this. I found one as well. Can you please apply the combo
| > | of those fixes to current mainline and test it ?
| > 
| >  Same problem, with or without CONFIG_HPET enabled.
| > 
| >  You think the problem you are discussing with Linus - the TSC
| > calibration issue - may have anything to do with this?
| 
| Dont think so. Your dmesg outputs do not show any sign of that
| disease.
| 
| Can you try the patch below please ?

 Did not work, also tried with latest Linus tree (which has
the fix for the TSC problem) but also failed.

 The only difference now is that this message:

"""
DMAR:parse DMAR table failure.
"""

 Is printed before the hpet0 ones.

-- 
Luiz Fernando N. Capitulino
