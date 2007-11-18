Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbXKRXqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbXKRXqx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 18:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbXKRXqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 18:46:45 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:40542 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbXKRXqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 18:46:44 -0500
Message-ID: <4740CEE4.8030800@tlinx.org>
Date: Sun, 18 Nov 2007 15:46:44 -0800
From: Lin Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 1.5.0.13 (Windows/20070809)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Config - general Q; default vs. suggested setting.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

More than once in going through configs for different
machines, I've noticed "oddities".  It's not clear which
are intentional and which 'leftovers' from changes.
Specifically, when I chose a new config by making
the default config, some of the default options
are different from what is recommended in the hint
text.

I.e. the default will have the option "on", but in the
hint(config) text, it says "this does xxyz, unless you know
what you are doing, say "no" here.
(or vice-versa)....  lets see; some examples:

Automatic kernel module loading:
Default=No, Text says "if unsure, say Y"

Under I/O Schedulers,
Default = Anticipatory, but text says: "CFQ is default"

SMT(Hyperthread)
Default:Y, Text:"If unsure say N"
Default:Y, Text:"If unsure say N"

....etc, etc...several (or many?) more...

So "Which is it"...or should there be a pattern?
If comment says "if unsure say N", or "most
users should say N", then should it be a bug
if "make defconfig" sets it to "T"("Y")?

Or should defconfig follow the help text (the answer
is probably that it depends, but does that mean a bug
should be filed against each instance?) 

I would think that the help/hint text should agree with
the default config or is there some reason for this not
to be the case?


Tnx,
Lin

