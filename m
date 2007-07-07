Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbXGGKG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbXGGKG6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 06:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbXGGKGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 06:06:51 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:54010 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752312AbXGGKGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 06:06:50 -0400
Date: Sat, 7 Jul 2007 12:06:49 +0200
From: DervishD <lkml@dervishd.net>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Question about cpufreq governors
Message-ID: <20070707100649.GB19299@DervishD>
Mail-Followup-To: Arjan van de Ven <arjan@infradead.org>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070706205045.GA2778@DervishD> <Pine.LNX.4.64.0707062353510.1536@fbirervta.pbzchgretzou.qr> <1183762229.2774.1.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1183762229.2774.1.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Arjan :)

 * Arjan van de Ven <arjan@infradead.org> dixit:
> On Fri, 2007-07-06 at 23:54 +0200, Jan Engelhardt wrote:
> > On Jul 6 2007 22:50, DervishD wrote:
> > >
> > >    What I want to know is if I can choose "ondemand" governor instead
> > >of the recommended for AMD64, namely the "conservative" governor, since
> > >I will be switching between those two frequencies. I haven't found any
> > >information about my CPU regarding latency when switching between
> > >frequencies, so I don't know if I will be gaining anything using the
> > >"conservative" governor.
> > >
> > >    Which governor is better suited for a CPU with only two fid's,
> > >"ondemand" or "conservative"?
> > 
> > Depends on what you want. ondemand instantly switches when there is
> > something/nothing to do, while conservative uses a threshold (modeled upon
> > latency).
> 
> for power saving, the ondemand behavior is better in general. However if
> you have a cpu that switches frequency very slowly, you may be better to
> not go as high quickly because going back down is then burning more
> power than needed potentially...

    That's the problem: I want to use "ondemand" but I don't know if it
will work properly with my CPU because I don't know if my CPU switches
frequency fast or slow :( I can find that information, although the
Kconfig file for cpufreq says that AMD64 has latency problems (but I can
confirm that, I'm afraid).

    Thanks for your answer :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
