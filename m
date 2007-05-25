Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbXEYG7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbXEYG7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 02:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbXEYG7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 02:59:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51754 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbXEYG7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 02:59:08 -0400
X-Greylist: delayed 65031 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 May 2007 02:59:08 EDT
Date: Fri, 25 May 2007 08:58:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070525065858.GA4257@elte.hu>
References: <E1HrC3W-0005SZ-00@dorka.pomaz.szeredi.hu> <20070524220816.GC23214@khazad-dum.debian.net> <46560E04.2090500@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46560E04.2090500@intel.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Kok, Auke <auke-jan.h.kok@intel.com> wrote:

> Henrique de Moraes Holschuh wrote:
> >On Thu, 24 May 2007, Miklos Szeredi wrote:
> >>Tried nmi_watchdog=1, but then the machine locks up hard shortly after
> >>boot.
> >
> >NMIs in some thinkpads are bad trouble, they lock up the blasted IBM/Lenovo
> >SMBIOS if they happen to hit it while it is servicing a SMI, and thinkpads
> >do SMIs like crazy.
> 
> there's also a L1 ASPM issue with the e1000 chipset in the way (for 
> T60/X60 only). Make sure you are using 2.6.21 or newer. See netdev 
> archives for more on that.

Miklos is using latest -git and he has nmi_watchdog disabled - still the 
long pauses persist. (i've never seen that on my t60)

	Ingo
