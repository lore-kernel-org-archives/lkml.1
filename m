Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYICNlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYICNlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 09:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYICNlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 09:41:11 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:43807 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbYICNlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 09:41:10 -0400
Date: Wed, 3 Sep 2008 10:41:32 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: herton@mandriva.com.br,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
Message-ID: <20080903104132.7a736282@doriath.conectiva>
In-Reply-To: <alpine.LFD.1.10.0809031202290.3243@apollo.tec.linutronix.de>
References: <20080902163532.436f8fbd@doriath.conectiva>
	<alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de>
	<20080902175544.131bc54e@doriath.conectiva>
	<alpine.LFD.1.10.0809031202290.3243@apollo.tec.linutronix.de>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 3 Sep 2008 12:04:58 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> escreveu:

| On Tue, 2 Sep 2008, Luiz Fernando N. Capitulino wrote:
| > """
| > PCI: Using ACPI for IRQ routing
| > DMAR:parse DMAR table failure.
| > """
| > 
| >  Also, after about 10 minutes I get the same backtrace as reported in
| > the ticket above... It's the same bug then.
| 
| Venki found a nasty bug in the clock events code which might be
| related to this. I found one as well. Can you please apply the combo
| of those fixes to current mainline and test it ?

 Same problem, with or without CONFIG_HPET enabled.

 You think the problem you are discussing with Linus - the TSC
calibration issue - may have anything to do with this?

 I'm going to trace where the kernel is getting stuck... If you
have any better suggestion, please, just say.

-- 
Luiz Fernando N. Capitulino
