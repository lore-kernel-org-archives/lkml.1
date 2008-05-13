Return-Path: <linux-kernel-owner+w=401wt.eu-S1758882AbYEMQmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882AbYEMQmH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 12:42:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755620AbYEMQl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 12:41:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40313 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780AbYEMQlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 12:41:55 -0400
Date: Tue, 13 May 2008 18:41:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oliver Endriss <o.endriss@gmx.de>
Cc: Johannes Stezenbach <js@linuxtv.org>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew de Quincey <adq_dvb@lidskialf.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch, 2.6.26-rc2] dvb: drivers/media/dvb/ttpci/fdump
	firmware build error fix
Message-ID: <20080513164140.GA21877@elte.hu>
References: <20080512101231.GA11755@elte.hu> <200805122218.15887@orion.escape-edv.de> <20080512204634.GA10620@linuxtv.org> <200805131633.55469@orion.escape-edv.de> <20080513163647.GA21678@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513163647.GA21678@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oliver Endriss <o.endriss@gmx.de> wrote:

> Sure. And without the patch you can simply add
> - STANDALONE=y or
> - DVB_AV7110_FIRMWARE=n
> to your allrandom.config. ;-)
 
hm, you are right - i've added STANDALONE=y previously but it went 
missing in action. So forget my patch, it was user error - the driver is 
right in that it already depends on STANDALONE :-) I guess STANDALONE 
should enable PREVENT_FIRMWARE_BUILD as well to avoid such errors ...

	Ingo
