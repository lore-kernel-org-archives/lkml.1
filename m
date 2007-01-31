Return-Path: <linux-kernel-owner+w=401wt.eu-S1030480AbXAaSJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030480AbXAaSJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030487AbXAaSJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:09:27 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:51102 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030480AbXAaSJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:09:25 -0500
Subject: Re: [PATCH 22/23] clocksource: new clock lookup method
From: Daniel Walker <dwalker@mvista.com>
To: tglx@linutronix.de
Cc: Ingo Molnar <mingo@elte.hu>, akpm@osdl.org, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com
In-Reply-To: <1170266132.29240.196.camel@localhost.localdomain>
References: <20070131033710.420168478@mvista.com>
	 <20070131033809.923199123@mvista.com> <20070131122215.GE1847@elte.hu>
	 <1170261439.9781.96.camel@imap.mvista.com>  <20070131164918.GA4468@elte.hu>
	 <1170265169.9781.145.camel@imap.mvista.com>
	 <1170266132.29240.196.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 10:07:54 -0800
Message-Id: <1170266874.9781.150.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 18:55 +0100, Thomas Gleixner wrote:
> On Wed, 2007-01-31 at 09:39 -0800, Daniel Walker wrote:
> > > please read my reply above! To repeat: such flags tend to get forgotten, 
> > > resulting in a less safe default behavior. Clock hardware and thus 
> > > clocksources are fundamentally fragile so we want to default to the 
> > > safest behavior. I.e. if the IS_CONTINOUS flag is 'forgotten', the clock 
> > > wont be usable as a clock verification base for example. The flag has to 
> > > be affirmatively set to mark the clocksource continous.
> > 
> > I don't see this as an issue .. Your assuming that not continuous clocks
> > will be prevalent which they aren't ..
> 
> And how does this change Ingo's statement ? Such beasts exist and having
> them default to the safe side is good. 
> 
> Also I really do not see the "huge burden" for a clocksource coder to
> add this flag. If he forgets it, then he can not use highres / dynticks
> and nothing breaks.

We're not talking about a rare system runtime configuration . If that
were the case I would agree safe is better..

I'm assuming that programmers will test their code, and others will
review the code .. Catering to any other situation doesn't make sense to
me. On top of that those clocks are rare, and not desirable ..

Daniel

