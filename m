Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbXFLWJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbXFLWJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 18:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750864AbXFLWIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 18:08:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbXFLWIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 18:08:52 -0400
Date: Tue, 12 Jun 2007 18:08:39 -0400
From: Dave Jones <davej@redhat.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Claas Langbehn <claas@rootdir.de>,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: VIA C7 / VIA PC-1 (PC2500) anyone?
Message-ID: <20070612220839.GA23098@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Michael Tokarev <mjt@tls.msk.ru>, Claas Langbehn <claas@rootdir.de>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <466E65A7.3000206@msgid.tls.msk.ru> <5699f8f00706120344h40fe6f88vb7601c9326bd589f@mail.gmail.com> <466E8A5B.4080205@msgid.tls.msk.ru> <466E976D.7060103@rootdir.de> <466E993D.5080308@msgid.tls.msk.ru> <Pine.LNX.4.64.0706122359080.19578@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706122359080.19578@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 11:59:36PM +0200, Jan Engelhardt wrote:
 > 
 > On Jun 12 2007 17:01, Michael Tokarev wrote:
 > >
 > >Claas Langbehn wrote:
 > >>> Hmm.  I wonder how to *enable* it in the first place.. ;)
 > >>> e_powersaver.ko and acpi_cpufreq gives "No such device"
 > >>>
 > >> cat /proc/cpuinfo and have a look at the flags. Does it support "eps"?
 > >
 > >I've looked at e_powersaver sources and noticied the second test in
 > >init function (after checking for CPU model) - it fails on this very
 > >test:
 > 
 > Actually you may want to try longhaul.ko

No, he doesn't.   Esther doesn't have longhaul.
The lack of EST in the feature flags is probably something
being disabled in the BIOS (or a crap BIOS).

	Dave

-- 
http://www.codemonkey.org.uk
