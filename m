Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbXIAJP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbXIAJP0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 05:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbXIAJPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 05:15:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53964 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbXIAJPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 05:15:13 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46D92D8E.9020508@s5r6.in-berlin.de>
Date: Sat, 01 Sep 2007 11:14:54 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: maturity and status and attributes, oh my!
References: <Pine.LNX.4.64.0708311720140.29153@localhost.localdomain> <46D89800.8080701@s5r6.in-berlin.de> <Pine.LNX.4.64.0708312109580.7060@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0708312109580.7060@localhost.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> *attributes* would be orthogonal to one another -- the values *within*
> an attribute would be mutually exclusive.

Ah, right.

...
> with regard to "experimental", what attribute would you imagine it
> would be a possible value for, and what other possible values might
> that attribute have as opposed to experimental?

In the context of kernel features, "experimental" doesn't mean that
developers are conducting experiments, but rather that users may use it
for experimental purposes.  Kernel packagers/ distributors/ admins/
users are advised that this feature is not for use in production (for
whatever reasons, e.g. proof-testing not completed, known instability,
lack of compatibility, missing features).

I have no advise into which attribute to put this and which alternative
values that attribute could assume.

But I can state requirements for the 'experimental' marker, from the POV
of a volunteer driver support guy:
  - Show it in big letters in the Kconfig prompt of an experimental
    feature.
  - Explain at appropriate place(s) what the particular caveats of the
    feature are.
That's it.  I am not aware of a need to evaluate this marker in routines
which calculate the .config, unlike the 'broken' marker.

BTW, the requirements of communication in feature removal processes are
similar to a degree.  But feature removal involves more active two-way
communication and is tied to a schedule.
-- 
Stefan Richter
-=====-=-=== =--= ----=
http://arcgraph.de/sr/
