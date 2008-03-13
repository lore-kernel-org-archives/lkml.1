Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbYCMHbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbYCMHbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 03:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbYCMHbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 03:31:08 -0400
Received: from main.carme.maven.pl ([193.239.45.138]:38620 "EHLO
	main.carme.maven.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYCMHbH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 03:31:07 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
Organization: SelfOrganizing
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Date: Thu, 13 Mar 2008 08:30:47 +0100
User-Agent: PLD Linux KMail/1.9.9
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20080225230035.GA14503@khazad-dum.debian.net> <20080312193637.GA27873@ics.muni.cz> <20080312211306.GD30864@khazad-dum.debian.net>
In-Reply-To: <20080312211306.GD30864@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803130830.47709.arekm@maven.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 of March 2008, Henrique de Moraes Holschuh wrote:
> On Wed, 12 Mar 2008, Lukas Hejtmanek wrote:
> > On Wed, Mar 12, 2008 at 07:52:41PM +0100, Arkadiusz Miskiewicz wrote:
> > > I'm also seeing regression on my thinkpad z60m where with git tree
> > > (tested again with 2 days old git) "thinkvantage" button stopped
> > > working (pressing it was previously seen by some userspace kde which
> > > run konsole).
> > >
> > > On 2.6.24 presses are seen.
> >
> > well, on 2.6.25-rc4, some keys are not reported as input (xev does not
> > see any key press), some keys are. Is this desired? Or all the keys
> > (fn+f1-12 + volume + backlight + think vantage) should be reported as
> > some input event and thus acpid makes no sense any more?
>
> xev has to get events from somewhere.  That somewhere happens to be a buggy
> mess right now (X.org evdev device).  Or it is getting it through some
> other middleware, like HAL, which can have its own problems.
>
> If you want to test thinkpad-acpi functionality, get HAL and X.org out of
> the way.  The easiest way is to do it in single user mode.

In my thinkpad z60m case. On 2.6.24 kernels pressing "thinkvantage" key is 
seen by acpid like this:

Mar 13 08:27:48 tarm acpid: received event "ibm/hotkey HKEY 00000080 00001018"
Mar 13 08:27:48 tarm acpid: notifying client 4071[126:126]
Mar 13 08:27:48 tarm acpid: notifying client 4096[0:0]
Mar 13 08:27:48 tarm acpid: notifying client 4230[0:0]
Mar 13 08:27:48 tarm acpid: completed event "ibm/hotkey HKEY 00000080 
00001018"
(this log was done while X was running + some kde apps).

Now under git kernel there is no such event. X has nothing to do with it since 
I tested without X running, too.

-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
