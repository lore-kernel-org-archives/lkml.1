Return-Path: <linux-kernel-owner+w=401wt.eu-S1757389AbYCMXO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbYCMXO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 19:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYCMXOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 19:14:17 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54796 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752567AbYCMXOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 19:14:16 -0400
X-Greylist: delayed 1266 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Mar 2008 19:14:16 EDT
X-Sasl-enc: gk97yLF/0k0doBLqF5rLio4UMugn31dmCbAqr9zjKg1x 1205448788
Date: Thu, 13 Mar 2008 19:53:02 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Message-ID: <20080313225301.GE30864@khazad-dum.debian.net>
References: <20080225230035.GA14503@khazad-dum.debian.net> <20080312133529.GB21290@khazad-dum.debian.net> <20080312135521.GE8141@ics.muni.cz> <200803121952.42666.arekm@maven.pl> <20080312193637.GA27873@ics.muni.cz> <20080312211306.GD30864@khazad-dum.debian.net> <20080313120514.GH17940@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313120514.GH17940@kernel.dk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008, Jens Axboe wrote:
> > If you want to test thinkpad-acpi functionality, get HAL and X.org out of
> > the way.  The easiest way is to do it in single user mode.
> 
> And lets now get back to reality - the reality that now breaks the
> previously working setup of lots of users. So you are telling me that in
> order to get my volume key functionality back I have to get rid of HAL
> and X?

I am telling you to go single user mode to check if the problem is in
thinkpad-acpi.  Nothing more, nothing less.  AFTER we find out where the
problem is, we see what should be done about it.

> Lets turn back time a bit. Why was this change made? IOW, what was the

What change?  For all we know, it could be a bug.  And if it is not a bug,
read the thinkpad-acpi documentation, and complain to me exactly about
whatever change described in there that is giving you issues.  Or give me a
bissect culprit.  Or do the testing I asked you to do, and tell me the
results.

> reason for breaking a working setup for lots of users? It better be a
> damn good reason, or I would heavily argue for reverting this change so
> that 2.6.25 actually WORKS as expected for thinkpad users.

I will get pissed very fast, if you keep up with this tone.  I certainly did
not send in any changes that should cause what you describe on purpose,
UNLESS you have disabled with the "deprecated" /proc/acpi/event stuff.  In
which case, it is your problem to get proper userspace.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
