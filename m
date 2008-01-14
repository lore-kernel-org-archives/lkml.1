Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbYANJmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbYANJmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 04:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbYANJml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 04:42:41 -0500
Received: from ns.firmix.at ([62.141.48.66]:3836 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbYANJmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:42:39 -0500
Subject: Re: The ext3 way of journalling
From: Bernd Petrovitsch <bernd@firmix.at>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <20080114071555.GA6475@jolt.modeemi.cs.tut.fi>
References: <18307.42821.166376.732473@stoffel.org>
	 <slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi>
	 <871w8r6ruc.fsf@barad-dur.regala.cx>
	 <slrnfo9lqk.17l.tuomov@jolt.modeemi.cs.tut.fi>
	 <20080110131659.GF10230@mit.edu>
	 <20080110134111.GA6254@jolt.modeemi.cs.tut.fi>
	 <20080112150621.GC6751@mit.edu>
	 <20080113221301.GA18341@jolt.modeemi.cs.tut.fi>
	 <20080113222310.GA20815@jolt.modeemi.cs.tut.fi>
	 <20080113231150.GB23906@mit.edu>
	 <20080114071555.GA6475@jolt.modeemi.cs.tut.fi>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Mon, 14 Jan 2008 10:42:23 +0100
Message-Id: <1200303743.24517.6.camel@tara.firmix.at>
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

On Mon, 2008-01-14 at 09:15 +0200, Tuomo Valkonen wrote:
[...]
> ntpdate isn't run by any of the init scripts. ntpd is, but like I 

Yes, that is a usual bug/problem in common distributions[0] as there is
no real guarantee that your clock is not far off.
Add your timeservers in /etc/ntp/step-tickers whereever your
distribution looks into to decide if ntpdate should run or activate the
ntpdate init.d script.
And some distributions run `ntpdate` quite late BTW ....

> already mentioned, I doubt it would correct vastly incorrect time,
> not even being able to track and correct when it advances fast.

That the reason to activate `ntpdate` unconditionally: It sets the
current time to an (somewhat) accurate value and `ntpd` handles the
rest.

	Bernd

[0]: Perhaps there is some reason for this. However I don't of any and
     none came ever to my mind.
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


