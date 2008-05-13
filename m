Return-Path: <linux-kernel-owner+w=401wt.eu-S1759670AbYEMQm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670AbYEMQm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 12:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755620AbYEMQmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 12:42:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40537 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868AbYEMQmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 12:42:49 -0400
Date: Tue, 13 May 2008 18:42:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: Oliver Endriss <o.endriss@gmx.de>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew de Quincey <adq_dvb@lidskialf.net>
Subject: Re: [patch, 2.6.26-rc2] dvb: drivers/media/dvb/ttpci/fdump
	firmware build error fix
Message-ID: <20080513164238.GB21877@elte.hu>
References: <20080512101231.GA11755@elte.hu> <200805122218.15887@orion.escape-edv.de> <20080512204634.GA10620@linuxtv.org> <200805131633.55469@orion.escape-edv.de> <20080513152359.GA26952@linuxtv.org> <20080513163930.GB21678@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513163930.GB21678@elte.hu>
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

> On Tue, May 13, 2008 at 04:33:54PM +0200, Oliver Endriss wrote:
> > Johannes Stezenbach wrote:
> > > You can put PREVENT_FIRMWARE_BUILD=y in your allrandom.config.
> > 
> > Sure. And without the patch you can simply add
> > - STANDALONE=y or
> > - DVB_AV7110_FIRMWARE=n
> > to your allrandom.config. ;-)
> 
> It is desirable to have one generic "don't break the build because of 
> missing firmware binaries" option, isn't it?

it's a bit confusing. PREVENT_FIRMWARE_BUILD=y is the 'weaker' option - 
a driver might still be operational (with its default firmware), even if 
no firmware is built. STANDALONE=y is the stronger option - if a driver 
depends on that it means that the driver cannot be built (and used) at 
all without a firmware file. To be on the safe side users who have no 
firmware needs should set both options. (and that's the default as well)

	Ingo
