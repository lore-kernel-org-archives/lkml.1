Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbYEMJvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbYEMJvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 05:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbYEMJvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 05:51:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38468 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbYEMJvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 05:51:36 -0400
Date: Tue, 13 May 2008 11:50:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Oliver Endriss <o.endriss@gmx.de>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew de Quincey <adq_dvb@lidskialf.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch, 2.6.26-rc2] dvb: drivers/media/dvb/ttpci/fdump
	firmware build error fix
Message-ID: <20080513095057.GA24037@elte.hu>
References: <20080512101231.GA11755@elte.hu> <200805121930.10909@orion.escape-edv.de> <20080512194630.GA10174@linuxtv.org> <200805122218.15887@orion.escape-edv.de> <20080512204634.GA10620@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512204634.GA10620@linuxtv.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Stezenbach <js@linuxtv.org> wrote:

> > > The point of PREVENT_FIRMWARE_BUILD is to make build testing with 
> > > "make randconfig" possible. I think you should ACK this patch, it 
> > > doesn't have any downsides for users of this driver.
> > 
> > No. If randconfig deselects both STANDALONE and 
> > PREVENT_FIRMWARE_BUILD, the same problem will happen again...
> 
> You can put PREVENT_FIRMWARE_BUILD=y in your allrandom.config.

yes. This is a clear bug and regression.

	Ingo
