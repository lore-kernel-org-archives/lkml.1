Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbYFDSwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbYFDSwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 14:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbYFDSwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 14:52:00 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64916 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751130AbYFDSwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 14:52:00 -0400
Date: Wed, 4 Jun 2008 19:51:15 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Stefan Assmann <sassmann@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>, Olaf Dabrunz <od@suse.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
In-Reply-To: <alpine.LFD.1.10.0806042032400.3235@apollo.tec.linutronix.de>
Message-ID: <Pine.LNX.4.55.0806041944420.28685@cliff.in.clinika.pl>
References: <12124107071847-git-send-email-od@suse.de> <m1tzgauduu.fsf@frodo.ebiederm.org>
 <4846651F.4070802@suse.de> <m1ve0pqy06.fsf@frodo.ebiederm.org>
 <48467DA7.9030309@suse.de> <Pine.LNX.4.55.0806041555370.28685@cliff.in.clinika.pl>
 <alpine.LFD.1.10.0806041801260.3235@apollo.tec.linutronix.de>
 <Pine.LNX.4.55.0806041755040.28685@cliff.in.clinika.pl>
 <alpine.LFD.1.10.0806041928390.3235@apollo.tec.linutronix.de>
 <Pine.LNX.4.55.0806041836110.28685@cliff.in.clinika.pl>
 <alpine.LFD.1.10.0806042032400.3235@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, Thomas Gleixner wrote:

> >  Anyway, my other questions remain open.  How is the INTx message actually
> > delivered to the ICH? 
> 
> I have roughly as much clue as you about that. The datashi^Heet is not
> really helpful.

 I haven't been following Intel's datasheets recently.  They usually do
publish all the necessary bits, but they are scattered around, so you
really have to read them all.  Chances are it's mentioned somewhere.  
Besides, I have no access to the PCI Express spec and there may be further
interesting bits there.  I suppose Intel can be queried directly too,
especially by the interested corporate parties.

> > And why is the command line option needed?
> 
> We don't want to impose that in the first place, but OTOH to get test
> coverage it's probably better to do it unconditionally.

 I gather with the workarounds disabled affected systems are useless 
anyway, so what's the point?

  Maciej
