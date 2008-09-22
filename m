Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbYIVJvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbYIVJvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 05:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYIVJvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 05:51:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59124 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbYIVJvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 05:51:40 -0400
Date: Mon, 22 Sep 2008 11:51:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gerhard Brauer <gerhard.brauer@web.de>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080922095111.GF17258@elte.hu>
References: <20080826171822.GB14906@Krystal> <20080826150222.0cf1542c@doriath.conectiva> <20080826181558.GA16887@Krystal> <20080826203449.GD5300@tux1.brauer.lan> <20080827161346.35b48d75@doriath.conectiva> <20080827233328.GC25531@Krystal> <20080828103013.163730ee@doriath.conectiva> <20080831092923.GB4305@tux1.brauer.lan> <20080831110942.7acaf82f@mandriva.com.br> <1222004499.4060.16.camel@tux1.brauer.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222004499.4060.16.camel@tux1.brauer.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0050]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gerhard Brauer <gerhard.brauer@web.de> wrote:

> Am Sonntag, den 31.08.2008, 11:09 -0300 schrieb Luiz Fernando N.
> Capitulino:
> 
> >  Mandriva kernel was 2.6.26.3 based at the time I started testing
> > this and all my last tests have been done on 2.6.27-rc4. I think it's
> > very unusual to have a change in a -stable kernel not present in the
> > latest -rc.
> 
> I was away the last days, but i notice that the virtualbox update to
> 2.0.2 solve all problems i mentioned. We also have same responses from
> other arch users.
> I never saw the "early boot oops" (this have had gone still with our
> kernel update, mystical....). But also the "heavy IO oops" has gone. So
> it was a virtualbox problem, they fixed it in:
> http://www.virtualbox.org/ticket/1875
> 
> So from my side this is solved.

great - the VirtualBox recompiler didnt notice the paravirt code 
modification sequence. Any Linux kernel side NOP issue (which caused 
that early oops) should be solved in 2.6.27-rc7 as well.

so the combo of 2.0.2 and later VirtualBox plus v2.6.27-rc7 and later 
should have no known bugs.

	Ingo
