Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbYHRDDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbYHRDDd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 23:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751179AbYHRDDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 23:03:25 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:9331 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYHRDDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 23:03:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=GWWI7K4oTKTBmg5I6JixPAZ2ggKSL8Uk8f39FxIC5JA9Ue2diML/zhb6C+EgFKy21s
         E2zdZBFv5f0ZTAwY+Ig+6sdZo8x/jAShP5q3WNCjB34QXHHAiDBd0yWroKtiihPpoDzj
         5yB9rsqM956m7v8Q+JBnDC+BYSKHZEBRIiBvw=
Message-ID: <fa4052ef0808172003r48863a4fu90c0647eef736571@mail.gmail.com>
Date: Sun, 17 Aug 2008 23:03:23 -0400
From: Shane <gnome42@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: WTF does -rc mean? was [PATCH] x86, tsc: fix section mismatch warning
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk  wrote ....
|On Sun, Aug 10, 2008 at 10:07:31PM -0700, H. Peter Anvin wrote:
|> Thanks!
|>
|> I have pulled these four patches into tip:x86/cleanups.
|
|Section fixes are not cleanups but bugfixes.
|
|E.g. this patch by Marcin fixes the following 2.6.27 regression
|(that was found 4 days after you applied his patch):
|http://bugzilla.kernel.org/show_bug.cgi?id=11330
|
|Can you make sure that Marcin's bugfixes makes it into 2.6.27?
|
|> -hpa
|
|TIA
|Adrian


------------------------------------------------------------------------------------------------------

This bug was causing my system to hang during boot at "Setting the
system Clock".
This was completely stopping me from testing the -rc3 kernel. I only tried this
patch on a hunch (tsc == clock :), I'm on intel hardware.

[ To: Adrian Bunk, Mark Lord (and other people with similar attitudes/ethics)
thanks for fixing and tracking everyone elses bugs for us lusers. And
the following
hopefully scorching flame is not meant for you guys. ]

This is the third** -rc cycle where I have composed what is meant to
be a scorching
email to the kernel list about the mind blowing decline in -rc kernel
developer attitude.
I didn't send the other two but I just spent another two flippin'
hours booting and
fsck'in. And I am very cranky  (to put it politely) because the
bleep'n problem is known
and the fix has been available for at least 7 days!!

I of course understand that there will be bugs in the -rc kernels,
that is why I bother putting
the time and energy into testing them.  It is mainly the lackadaisical
attitude about getting
the fixes in that is a mind blower.

I am a (fairly long time) tester/luser of the kernel. I do it for fun
and to learn.
It isn't fun anymore.


** A couple examples of what I'm talking about:

http://www.gossamer-threads.com/lists/linux/kernel/852762#852762

http://www.gossamer-threads.com/lists/linux/kernel/853094#853094

This one is my least favourite. That r8169 bug required me to unplug
my box overnight
just to get back on the network.  I foolishly thought that a bug like
that on such a popular
piece of hardware would not be allowed to persist in mainline for
long, so I foolishly
updated my kernel a few times (waiting days in between) and my box was basically
bricked overnight each time!! :((

The maintainer's attitude makes me want to chisel that chip right off my board.
Thanks again to Mark Lord!

http://www.gossamer-threads.com/lists/linux/kernel/841017#841017

Andrew was my hero on this one. Thanks Andrew!
http://www.gossamer-threads.com/lists/linux/kernel/852734#852734

( I doubt I have anything else useful to say about this so I likely
won't be posting
again to this thread )

Shane
