Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbXINTT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbXINTT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 15:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758015AbXINTTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 15:19:50 -0400
Received: from www.osadl.org ([213.239.205.134]:33284 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757975AbXINTTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 15:19:49 -0400
Subject: RE: cpu hotplug support broken in 2.6.23-rc3
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeff Chua <jeff.chua.linux@gmail.com>, rusty@rustycorp.com.au,
       vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F501619542@scsmsx415.amr.corp.intel.com>
References: <20070827104350.GA2073@elf.ucw.cz>
	 <b6a2187b0708280721w20d5dc44q249642f7946ae55a@mail.gmail.com>
	 <20070903034720.GB3655@ucw.cz> <200709031219.12846.rjw@sisk.pl>
	 <1188822917.3406.0.camel@chaos>
	 <20070904072744.GA30474@atrey.karlin.mff.cuni.cz>
	 <1189713695.3974.23.camel@chaos>  <20070914123816.GE1671@elf.ucw.cz>
	 <1189774257.3100.7.camel@chaos>
	 <653FFBB4508B9042B5D43DC9E18836F501619542@scsmsx415.amr.corp.intel.com>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 21:18:03 +0200
Message-Id: <1189797483.3707.3.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 (2.11.92-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-14 at 11:49 -0700, Pallipadi, Venkatesh wrote:
> >> 
> >> Is there a patch you want me to test? Or does Len have anything to
> >> play with?
> >
> >Venki sent me an initial patch, but it has issues with the notify
> >ordering. Find below my "cache the broadcast flags" version 
> >for testing.
> >
> 
> While wirting that patch, I knew solution could not be that simple :(.
> Does the patch work for online offline case atleast?
> Will look at the Suspend/Resume ordering part in that case.

Yup, the online/offline part works and it helped me to decode the other
reason (/me needs a dark brown paperbag) why Pavel noticed that his box
turned into a brick. I'll send out a full series of fixups (including
your online/offline one) tomorrow morning. I want to give that some more
testing.

Vs. the resume reevaluation: I don't think it's an urgent problem. It's
only my VAIO which does not tell the kernel after resume that the power
supply source has changed. All my other boxen do that and we never had a
complaint about that from other folks.

	tglx


