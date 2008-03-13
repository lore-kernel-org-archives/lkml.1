Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbYCMXRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbYCMXRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 19:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbYCMXRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 19:17:41 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39439 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752203AbYCMXRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 19:17:40 -0400
X-Sasl-enc: 7c5kfmKIYJXn1U4Q3gFyopjvGoA6J89P22EPLd0a3Ws9 1205450259
Date: Thu, 13 Mar 2008 20:17:38 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
Message-ID: <20080313231738.GH30864@khazad-dum.debian.net>
References: <20080225230035.GA14503@khazad-dum.debian.net> <20080312133529.GB21290@khazad-dum.debian.net> <20080312135521.GE8141@ics.muni.cz> <200803121952.42666.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803121952.42666.arekm@maven.pl>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Arkadiusz Miskiewicz wrote:
> > On Wed, Mar 12, 2008 at 10:35:29AM -0300, Henrique de Moraes Holschuh wrote:
> > > You shouldn't need to do anything other than teach userspace to respond
> > > to them, as they generate the proper KEY_* events.  If you are giving the
> > > AML _OSI(Linux), at least...
> 
> I'm also seeing regression on my thinkpad z60m where with git tree (tested 
> again with 2 days old git) "thinkvantage" button stopped working (pressing it 
> was previously seen by some userspace kde which run konsole).
> 
> On 2.6.24 presses are seen.

There were no changes to thinkpad-acpi that should have caused this.  So I
need more data to find out what is happening.  Might be a problem elsewhere
in ACPI, or some bug in thinkpad-acpi.

You DO have /proc/acpi/event, correct?  Please send me the debug output of
thinkpad-acpi when it is loaded with "debug=0xffff" as a parameter (and for
extra bonus, please compile it with the verbose debug Kconfig option).

Also, send me the output of 
"grep . /sys/bus/platform/devices/thinkpad_acpi/*"

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
