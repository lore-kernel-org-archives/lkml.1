Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbXICKLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbXICKLP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753326AbXICKK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:10:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:13161 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbXICKK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:10:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=T2NN/IUhvXFaaxmsvouKNbQ9SZk1+rtegACzX7GRGPKgD9vPRoKY3yOf9kH2XWR/GnzSKfOzgetQop7oBWScLTFwkhO2AHbF6GE19tCRB1v2XryE5Us1hZkx1r7dVOgF9Fp0MSUNoHmn3bCgGw9okNTK3N6zlq1aNlkTdvn5ais=
Message-ID: <46DBDD8B.7040706@googlemail.com>
Date: Mon, 03 Sep 2007 12:10:19 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Markus <lists4me@web.de>, Jeff Chua <jeff.chua.linux@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
       dth <dth@dth.net>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Clayton <andrew@digital-domain.net>,
       Peter Kovar <peter.kovar@gmail.com>
Subject: Re: [2/4] 2.6.23-rc5: known regressions
References: <46DBD982.3080102@googlemail.com>
In-Reply-To: <46DBD982.3080102@googlemail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc5.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            9
Linus Torvalds                         6
Andi Kleen                             5
Hugh Dickins                           5
Andrew Morton                          4
Al Viro                                3
Alan Stern                             3
Alexey Starikovskiy                    3
Cornelia Huck                          3
Jens Axboe                             3
Stephen Hemminger                      3
Tejun Heo                              3



Unclassified

Subject         : console is messed up after resume from s2ram or switching to console from X
References      : http://lkml.org/lkml/2007/8/4/6
Last known good : ?
Submitter       : Jeff Chua <jeff.chua.linux@gmail.com>
Caused-By       : ?
Handled-By      : H. Peter Anvin <hpa@zytor.com>
                  Antonino A. Daplas <adaplas@gmail.com>
Workaround      : "s2ram --force --acpi_sleep 1 --vbe_mode"
Status          : problem is being debugged

Subject         : konqueror suddenly vanishing, "konqueror: Fatal IO error: client killed"
References      : http://lkml.org/lkml/2007/7/22/86
Last known good : ?
Submitter       : Markus <lists4me@web.de>
Caused-By       : ?
Handled-By      : Ingo Molnar <mingo@elte.hu>
Status          : problem is being debugged



CPUFREQ

Subject         : ide problems: 2.6.22-git17 working, 2.6.23-rc1* is not
References      : http://lkml.org/lkml/2007/7/27/298
                  http://lkml.org/lkml/2007/7/29/371
Last known good : ?
Submitter       : dth <dth@dth.net>
Caused-By       : Len Brown <lenb@kernel.org>
                  commit f79e3185dd0f8650022518d7624c876d8929061b
Handled-By      : Len Brown <lenb@kernel.org>
Status          : problem is being debugged


FS

Subject         : NFSv3 server error in LOOKUP after READDIRPLUS Call
References      : http://bugzilla.kernel.org/show_bug.cgi?id=8966
Last known good : ?
Submitter       : Peter Kovar <peter.kovar@gmail.com>
Caused-By       : ?
Handled-By      : ?
Status          : unknown

Subject         : [NFSD OOPS] 2.6.23-rc1-git10
References      : http://lkml.org/lkml/2007/8/2/462
Last known good : ?
Submitter       : Andrew Clayton <andrew@digital-domain.net>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
