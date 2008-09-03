Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbYICS6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbYICS6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbYICS6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:58:31 -0400
Received: from www.tglx.de ([62.245.132.106]:44959 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339AbYICS6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:58:30 -0400
Date: Wed, 3 Sep 2008 20:58:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dmitry Nezhevenko <dion@inhex.net>
cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       herton@mandriva.com.br,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
In-Reply-To: <20080903175407.GA27480@laptop.local>
Message-ID: <alpine.LFD.1.10.0809032054110.3243@apollo.tec.linutronix.de>
References: <20080902163532.436f8fbd@doriath.conectiva> <alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de> <20080902175544.131bc54e@doriath.conectiva> <alpine.LFD.1.10.0809031202290.3243@apollo.tec.linutronix.de> <20080903104132.7a736282@doriath.conectiva>
 <alpine.LFD.1.10.0809031635260.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809031713040.3243@apollo.tec.linutronix.de> <20080903164415.GA24442@laptop.local> <alpine.LFD.1.10.0809031857020.3243@apollo.tec.linutronix.de>
 <20080903175407.GA27480@laptop.local>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Dmitry Nezhevenko wrote:
  
> Actually kernel continued to boot, however it panics just before (or maybe
> after) mounting rootfs... I've booted it with boot_delay to take photos.

Ok. The second one is a WARNING as well. That's a separate issue. The
broadcast code tries to send an IPI to a CPU which is not online. Urgh.
 
> I'm using linux-2.6-x86.git as suggested by Glauber

Can you please try mainline with all the hpet patches applied ?

Thanks,

	tglx
