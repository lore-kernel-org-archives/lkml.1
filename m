Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbYICTgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbYICTgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 15:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754451AbYICTg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 15:36:28 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:59579 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbYICTg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 15:36:27 -0400
Date: Wed, 3 Sep 2008 16:36:48 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Nezhevenko <dion@inhex.net>, herton@mandriva.com.br,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
Message-ID: <20080903163648.785d16e0@doriath.conectiva>
In-Reply-To: <alpine.LFD.1.10.0809032109070.3243@apollo.tec.linutronix.de>
References: <20080902163532.436f8fbd@doriath.conectiva>
	<alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de>
	<20080902175544.131bc54e@doriath.conectiva>
	<alpine.LFD.1.10.0809031202290.3243@apollo.tec.linutronix.de>
	<20080903104132.7a736282@doriath.conectiva>
	<alpine.LFD.1.10.0809031635260.3243@apollo.tec.linutronix.de>
	<alpine.LFD.1.10.0809031713040.3243@apollo.tec.linutronix.de>
	<20080903164415.GA24442@laptop.local>
	<alpine.LFD.1.10.0809031857020.3243@apollo.tec.linutronix.de>
	<20080903143653.68bb58df@doriath.conectiva>
	<alpine.LFD.1.10.0809032030271.3243@apollo.tec.linutronix.de>
	<20080903160705.0efd7308@doriath.conectiva>
	<alpine.LFD.1.10.0809032109070.3243@apollo.tec.linutronix.de>
Organization: Mandriva
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.13.7; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, 3 Sep 2008 21:10:15 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> escreveu:

| On Wed, 3 Sep 2008, Luiz Fernando N. Capitulino wrote:
| >  Yeah, it works. I have booted three times with no warnings.
| > 
| >  I will revert the debug patch and test again just to be sure, if
| > this is of any help:
| > 
| > Tested-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
| > 
| >  By the way, is this the definitive fix?
| 
| Part of it. I will keep a more clever force exit from the program
| loops to avoid that once and forever.

 Great. Would you mind to CC me when you have the final fix so
that I can apply it in the Mandriva kernel (in case we release a
new kernel before mainline with the fix).

 Just to confirm, works w/o the debug patch applied.

 Thanks a lot.

-- 
Luiz Fernando N. Capitulino
