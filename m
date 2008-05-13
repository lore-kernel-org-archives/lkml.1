Return-Path: <linux-kernel-owner+w=401wt.eu-S1760257AbYEMOt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257AbYEMOt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 10:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbYEMOtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 10:49:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40106 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbYEMOtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 10:49:17 -0400
Date: Tue, 13 May 2008 16:49:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oliver Endriss <o.endriss@gmx.de>
Cc: Johannes Stezenbach <js@linuxtv.org>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew de Quincey <adq_dvb@lidskialf.net>
Subject: Re: [patch, 2.6.26-rc2] dvb: drivers/media/dvb/ttpci/fdump
	firmware build error fix
Message-ID: <20080513144900.GD4697@elte.hu>
References: <20080512101231.GA11755@elte.hu> <200805122218.15887@orion.escape-edv.de> <20080512204634.GA10620@linuxtv.org> <200805131633.55469@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805131633.55469@orion.escape-edv.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0061]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oliver Endriss <o.endriss@gmx.de> wrote:

> > > No. If randconfig deselects both STANDALONE and PREVENT_FIRMWARE_BUILD,
> > > the same problem will happen again...
> > 
> > You can put PREVENT_FIRMWARE_BUILD=y in your allrandom.config.
> 
> Sure. And without the patch you can simply add
> - STANDALONE=y or
> - DVB_AV7110_FIRMWARE=n
> to your allrandom.config. ;-)

Uhm, cart pulls horse alert. There's a reason PREVENT_FIRMWARE_BUILD 
exists and is used by all other drivers in the tree that have a firmware 
build method. Yours is the only one that regresses.

	Ingo
