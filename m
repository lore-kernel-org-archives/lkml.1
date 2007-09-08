Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbXIHLOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbXIHLOO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 07:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbXIHLNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 07:13:11 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:46533 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbXIHLNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 07:13:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=VC36suo6XoKwRyFMRoOyypQMd6Z0yf40BaPL2YmsDKjREb6/Wodf/B0VOjjFgdPSAvgDZPVhY4ariQij876TCfPcK3sSgae0LwEvjV6gDdCa7BQsMC0kAvoLoRgHwyKecC/+WwGVW73ATL4a+LesjPKYPkI+YYDdNbe4X89ctCU=
Message-ID: <46E28367.2070001@googlemail.com>
Date: Sat, 08 Sep 2007 13:11:35 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>,
       Andrey Borzenkov <arvidjaar@mail.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, Trond Myklebust <Trond.Myklebust@netapp.com>,
       Peter Kovar <peter.kovar@gmail.com>, Neil Brown <neilb@suse.de>,
       linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Bret Towe <magnade@gmail.com>, Tony Breeds <tony@bakeyournoodle.com>
Subject: [1/2] 2.6.23-rc5: known regressions with patches v2
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



Unclassified

Subject         : 8250 claims non existing device blocking IO port
References      : http://lkml.org/lkml/2007/8/18/20
Last known good : ?
Submitter       : Andrey Borzenkov <arvidjaar@mail.ru>
Caused-By       : ?
Handled-By      : Bjorn Helgaas <bjorn.helgaas@hp.com>
Patch           : http://lkml.org/lkml/2007/8/21/291
Status          : patch available

Subject         : Oops while modprobing phy fixed module
References      : http://lkml.org/lkml/2007/7/14/63
Last known good : ?
Submitter       : Gabriel C <nix.or.die@googlemail.com>
Caused-By       : ?
Handled-By      : Satyam Sharma <satyam.sharma@gmail.com>
                  Vitaly Bordug <vitb@kernel.crashing.org>
Patch1          : http://lkml.org/lkml/2007/7/18/506
Status          : patch available



FS

Subject         : NFSv3 server error in LOOKUP after READDIRPLUS Call
References      : http://bugzilla.kernel.org/show_bug.cgi?id=8966
Last known good : ?
Submitter       : Peter Kovar <peter.kovar@gmail.com>
Caused-By       : ?
Handled-By      : Neil Brown <neilb@suse.de>
Patch           : http://bugzilla.kernel.org/attachment.cgi?id=12689
Status          : patch available



IDE

Subject         : linux-2.6.23-rc4 ppc build failure
References      : http://lkml.org/lkml/2007/8/29/154
Last known good : ?
Submitter       : Bret Towe <magnade@gmail.com>
Caused-By       : ?
Handled-By      : Tony Breeds <tony@bakeyournoodle.com>
Patch           : http://lkml.org/lkml/2007/8/31/1
Status          : patch was suggested



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
