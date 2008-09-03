Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbYICTBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbYICTBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 15:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbYICTB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 15:01:28 -0400
Received: from inhex.net ([193.33.178.145]:55054 "EHLO inhex.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbYICTB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 15:01:27 -0400
Date: Wed, 3 Sep 2008 22:01:05 +0300
From: Dmitry Nezhevenko <dion@inhex.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       herton@mandriva.com.br,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
Message-ID: <20080903190105.GA3660@laptop.local>
References: <alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de> <20080902175544.131bc54e@doriath.conectiva> <alpine.LFD.1.10.0809031202290.3243@apollo.tec.linutronix.de> <20080903104132.7a736282@doriath.conectiva> <alpine.LFD.1.10.0809031635260.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809031713040.3243@apollo.tec.linutronix.de> <20080903164415.GA24442@laptop.local> <alpine.LFD.1.10.0809031857020.3243@apollo.tec.linutronix.de> <20080903143653.68bb58df@doriath.conectiva> <alpine.LFD.1.10.0809032030271.3243@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809032030271.3243@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 08:40:55PM +0200, Thomas Gleixner wrote:
> I now see why this is happening and it is happening only on systems
> with a fast HPET. Your's running 25MHz, so the delta is only 1.92
> usec. I was staring at lots of those bugreports without noticing the
> frequency.
> 
> Sigh. The idea to take a fixed number of HPET cycles as the minimum
> was not really brilliant it seems.
> 
> Does the patch below help ? Keep the debug patch applied, as we can
> see whether the check triggers or not.

Works for me... I'm just got only second backtrace after mounting rootfs.
Looks like something is broken with  git tree. 
 
-- 
WBR, Dmitry
