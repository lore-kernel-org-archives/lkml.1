Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbXLTTHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbXLTTHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 14:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757262AbXLTTHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 14:07:06 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:40784 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbXLTTHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 14:07:05 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <476ABD53.10909@s5r6.in-berlin.de>
Date: Thu, 20 Dec 2007 20:06:59 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as
 well
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de> <200712200313.54425.volker.armin.hemmann@tu-clausthal.de> <476A8965.40703@s5r6.in-berlin.de> <200712201912.37416.volker.armin.hemmann@tu-clausthal.de>
In-Reply-To: <200712201912.37416.volker.armin.hemmann@tu-clausthal.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hemmann, Volker Armin wrote:
> On Donnerstag, 20. Dezember 2007, you wrote:
>> The subject line is wrong.
>> You apparently run Linux, but not Linux 2.6.23.y.
> 
> first of all, apart from this oops all other oopses I reported were with a 
> not-tainted kernel. You might want to read the other mails I have sent.
> 
> Also, besides of the reiser4 patch there is no other patch added to the 
> kernel. And since people have had  successfully reported problems with 
> heavily distro-patched kernels in the past it looks a little bit hypocritical 
> to put my reports aside because of one single patch - don't you think?

I didn't say anything about putting your report aside.

For successful reports (as in 'leading to a fix'), it's among else
necessary that the issue can be narrowed down enough.  Sometimes this is
a quick process; e.g. user X finds a very specific driver bug while
using a patched and old kernel, driver developer Y takes the time to
confirm this bug in a recent mainline kernel because he already had a
good idea where to look and how to recreate the respective conditions,
and fixes the bug.  Sometimes it takes much much more work to identify
the circumstances of the bug.  It is then necessary that the reporter
knows exactly what he is running, simplifies his system to eliminate as
many potential causes for problems as possible, and always clearly
states under what circumstances the bug happens.

If you already found the bug in an untainted (but patched?) kernel, then
what information does another report against a tainted kernel add?  The
tainted kernel has more unknowns than the untainted one.  Progress can
only be made if the number of unknowns are successively reduced.

Regarding other people's reports and hypocrisy and whatnot:  I myself am
monitoring a few distro bug trackers more or less frequently for bug
reports concerning the kernel subsystem I'm interested in.  With varying
success though.  In order make use of a report against a distro kernel,
I need to have a good picture of what stuff is in that kernel.  Looking
at distro bug trackers does only work for me because my field of
interest is a driver subsystem which is somewhat decoupled from other
kernel parts; so if there is trouble concerning hardware covered by this
subsystem, it is usually not too hard to figure out whether the problem
is in this subsystem or somewhere else.  If it weren't that easy most of
the time, I might for example depend on the reporters to test specific
mainline kernels or specific development kernels.  (Though the latter
becomes necessary after all in cases when more targeted debug output is
needed from the reporter, or in order to test proposed fixes without
having to wait for the distributor to build a test package for the
reporter.)
-- 
Stefan Richter
-=====-=-=== ==-- =-=--
http://arcgraph.de/sr/
