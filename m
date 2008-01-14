Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYANLS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYANLS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 06:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbYANLSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 06:18:15 -0500
Received: from ns.firmix.at ([62.141.48.66]:4152 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbYANLSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 06:18:14 -0500
Subject: Re: The ext3 way of journalling
From: Bernd Petrovitsch <bernd@firmix.at>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080114111158.GB29126@jolt.modeemi.cs.tut.fi>
References: <20080110131659.GF10230@mit.edu>
	 <20080110134111.GA6254@jolt.modeemi.cs.tut.fi>
	 <20080112150621.GC6751@mit.edu>
	 <20080113221301.GA18341@jolt.modeemi.cs.tut.fi>
	 <20080113222310.GA20815@jolt.modeemi.cs.tut.fi>
	 <20080113231150.GB23906@mit.edu>
	 <20080114071555.GA6475@jolt.modeemi.cs.tut.fi>
	 <1200303743.24517.6.camel@tara.firmix.at>
	 <slrnfombug.lco.tuomov@jolt.modeemi.cs.tut.fi>
	 <1200304629.24517.15.camel@tara.firmix.at>
	 <20080114111158.GB29126@jolt.modeemi.cs.tut.fi>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Mon, 14 Jan 2008 12:18:06 +0100
Message-Id: <1200309486.24517.28.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.334 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.334 required=5
X-Spam-Score: -2.334 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-14 at 13:11 +0200, Tuomo Valkonen wrote:
> On 2008-01-14 10:57 +0100, Bernd Petrovitsch wrote:
> > That leads to the question why the clock starts to run like crazy at
> > some time so that `ntpd` can't cope with it.
> 
> I do wonder whether the PSU could've been causing it. Now that think

We have some embedded systems where some strange problems[0] were caused
by bad/cheap/low-quality PSUs.

> about it, I got the PSU around two years ago, just like I compiled 
> 2.6.14. This PSU coincidentally seems to have been the cause of the 
> crash that started this thread, and went completely silent during 
> the same day, on the third crash. But even if the PSU could cause
> the timer interrupt to signal too frequently or so, doesn't explain
> why nearly always after a crash (when journal recovery would be the
> normal course of action), fsck starts checking with absurd intervals
> since last check, whereas there's no trouble booting after normal
> shutdown.

But for normal PCs, I don't know how much the quality of a PSU is
relevant for the speed of the clock.
Can you test with a different PSU?

	Bernd

[0]: I don't know more details out of the top of my head.
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


