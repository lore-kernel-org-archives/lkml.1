Return-Path: <linux-kernel-owner+w=401wt.eu-S933599AbXDGAQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599AbXDGAQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 20:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933605AbXDGAQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 20:16:55 -0400
Received: from khc.piap.pl ([195.187.100.11]:46040 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933611AbXDGAQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 20:16:53 -0400
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: David Brownell <david-b@pacbell.net>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: coding style for long conditions (WAS: Re: [PATCH 25/90] ... blinky leds!!)
References: <11757099691323-git-send-email-tony@atomide.com>
	<200704061029.55710.david-b@pacbell.net>
	<46169968.2050006@s5r6.in-berlin.de>
	<200704061405.50169.david-b@pacbell.net>
	<Pine.LNX.4.61.0704062351580.6042@yvahk01.tjqt.qr>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 07 Apr 2007 02:16:51 +0200
In-Reply-To: <Pine.LNX.4.61.0704062351580.6042@yvahk01.tjqt.qr> (Jan Engelhardt's message of "Fri, 6 Apr 2007 23:53:45 +0200 (MEST)")
Message-ID: <m3fy7dt4wc.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@linux01.gwdg.de> writes:

> Tabs should be used for indent, not padding. People wanting to use
> different-sized tabs can change settings in their editor, i.e.
> to make a tab 12 instead of 8. Or 6. Or whatever. If tabs only ever
> appear at the front, this works, it breaks when tabs are used to line
> up foo->bar=1; foo->boom=17; statements.

Precisely.

If someone really likes

if (a &&
	b)

or

if (
	a
	&&
	b
)

then let be it (in his/her code), but please don't fight

if (a &&
    b)

Just make sure only tabs are used for indent, i.e., the last is:
\t*if (a &&
\t*\s\s\s\sb)

another example:

\t*if (condition1 && (a +
\t*                   b))
   ^^^^^^^^^^^^^^^^^^^ <<< spaces, not tabs

I think the current CodingStyle is clear enough but improvements there
aren't prohibited.
-- 
Krzysztof Halasa
