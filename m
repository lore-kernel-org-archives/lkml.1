Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbYICTKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbYICTKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 15:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbYICTKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 15:10:31 -0400
Received: from www.tglx.de ([62.245.132.106]:55815 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236AbYICTKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 15:10:30 -0400
Date: Wed, 3 Sep 2008 21:10:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
cc: Dmitry Nezhevenko <dion@inhex.net>, herton@mandriva.com.br,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
In-Reply-To: <20080903160705.0efd7308@doriath.conectiva>
Message-ID: <alpine.LFD.1.10.0809032109070.3243@apollo.tec.linutronix.de>
References: <20080902163532.436f8fbd@doriath.conectiva> <alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de> <20080902175544.131bc54e@doriath.conectiva> <alpine.LFD.1.10.0809031202290.3243@apollo.tec.linutronix.de> <20080903104132.7a736282@doriath.conectiva>
 <alpine.LFD.1.10.0809031635260.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809031713040.3243@apollo.tec.linutronix.de> <20080903164415.GA24442@laptop.local> <alpine.LFD.1.10.0809031857020.3243@apollo.tec.linutronix.de> <20080903143653.68bb58df@doriath.conectiva>
 <alpine.LFD.1.10.0809032030271.3243@apollo.tec.linutronix.de> <20080903160705.0efd7308@doriath.conectiva>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008, Luiz Fernando N. Capitulino wrote:
>  Yeah, it works. I have booted three times with no warnings.
> 
>  I will revert the debug patch and test again just to be sure, if
> this is of any help:
> 
> Tested-by: Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>
> 
>  By the way, is this the definitive fix?

Part of it. I will keep a more clever force exit from the program
loops to avoid that once and forever.

Thanks,

	tglx
