Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbXIHLOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbXIHLOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 07:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbXIHLNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 07:13:14 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:7623 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbXIHLNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 07:13:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=LI1pq02gRBWXRxpE0gaGTaYFwBl8jvCcbd4qkVCXstwZ0LAYeWjJoeQlIyN/xYboEaCMeLsFJxdiGIgov9kjNVIduwRNGlmOwPyAc4WcR6XE0AbTq2S6u7e3AcfufLYy85DfpIASWbERX4KHRtcdwCgm877SbxqGeaVHo04PUvU=
Message-ID: <46E2836B.60406@googlemail.com>
Date: Sat, 08 Sep 2007 13:11:39 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Christian Casteyde <casteyde.christian@free.fr>,
       Alan Stern <stern@rowland.harvard.edu>, netdev@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       Florian Lohoff <flo@rfc822.org>, linux-wireless@vger.kernel.org,
       Christian Casteyde <casteyde.christian@free.fr>,
       Martin Langer <martin-langer@gmx.de>, Stefano Brivio <st3@riseup.net>,
       Michael Buesch <mbuesch@freenet.de>,
       Danny van Dyk <kugelfang@gentoo.org>,
       Andreas Jaggi <andreas.jaggi@waterwave.ch>
Subject: Re: [2/2] 2.6.23-rc5: known regressions with patches v2
References: <46E28149.2090900@googlemail.com>
In-Reply-To: <46E28149.2090900@googlemail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc5
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            10
Linus Torvalds                         6
Andi Kleen                             5
Hugh Dickins                           5
Trond Myklebust                        5
Andrew Morton                          4
Al Viro                                3
Alan Stern                             3
Alexey Starikovskiy                    3
Cornelia Huck                          3
David S. Miller                        3
Jens Axboe                             3
Stephen Hemminger                      3
Tejun Heo                              3



Some of these patches are available in -krf (known regressions fixes) tree
http://www.stardust.webpages.pl/files/patches/krf/2.6.23-rc5-git1/linux-2.6.23-rc5-git1-krf1.patch.bz2
http://www.stardust.webpages.pl/files/patches/krf/2.6.23-rc5-git1/linux-2.6.23-rc5-git1-krf1.tar.bz2



MMC

Subject         : Unable to access memory card reader anymore
References      : http://bugzilla.kernel.org/show_bug.cgi?id=8885
Last known good : ?
Submitter       : Christian Casteyde <casteyde.christian@free.fr>
Caused-By       : ?
Handled-By      : Alan Stern <stern@rowland.harvard.edu>
Patch           : http://bugzilla.kernel.org/attachment.cgi?id=12438
Status          : patch available



Networking

Subject         : ifconfig eth1 - scheduling while atomic: ifconfig/0x00000002/4170
References      : http://lkml.org/lkml/2007/9/2/165
Last known good : ?
Submitter       : Florian Lohoff <flo@rfc822.org>
Caused-By       : ?
Handled-By      : Johannes Berg <johannes@sipsolutions.net>
Patch           : http://lkml.org/lkml/2007/9/7/75
Status          : patch available

Subject         : System freeze when restarting network connection with Broadcom driver
References      : http://bugzilla.kernel.org/show_bug.cgi?id=8934
Last known good : ?
Submitter       : Christian Casteyde <casteyde.christian@free.fr>
Caused-By       : ?
Handled-By      : ?
Status          : patch has been submitted to John Linville



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
