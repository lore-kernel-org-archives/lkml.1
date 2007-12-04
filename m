Return-Path: <linux-kernel-owner+w=401wt.eu-S1752779AbXLDKzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbXLDKzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 05:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbXLDKzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 05:55:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57723 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbXLDKzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 05:55:04 -0500
Date: Tue, 4 Dec 2007 11:54:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Patrick Boettcher <pb@linuxtv.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [build bug] undefined reference to
	`dib3000mc_get_tuner_i2c_master'
Message-ID: <20071204105439.GA20175@elte.hu>
References: <20071204083904.GA15694@elte.hu> <Pine.LNX.4.64.0712041130310.16564@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712041130310.16564@twin.jikos.cz>
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


* Jiri Kosina <jikos@jikos.cz> wrote:

> On Tue, 4 Dec 2007, Ingo Molnar wrote:
> 
> > with the attached config i get this build failure:
> >  drivers/built-in.o: In function `dibusb_dib3000mc_tuner_attach':
> >  : undefined reference to `dib3000mc_get_tuner_i2c_master'
> >  drivers/built-in.o: In function `dibusb_dib3000mc_tuner_attach':
> >  : undefined reference to `dib3000mc_set_config'
> > on 2.6.24-rc-latest.
> 
> Hmm, seems like -common part contains also code that is not completely 
> common to all the modules.
> 
> How about this?

that does the trick and 2.6.24-rc4 now builds & boots fine with that 
config. Thanks,

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
