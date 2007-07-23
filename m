Return-Path: <linux-kernel-owner+w=401wt.eu-S1765124AbXGWJuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765124AbXGWJuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 05:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760041AbXGWJtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 05:49:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:13535 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756848AbXGWJtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 05:49:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=cQSuli4sW6Q8n2Fx/6cfWG/UJWCqR4UmPreT2TsaM9mvjLrgMKUaAVEjHjT4rSg4TSd+/43PRI12RODKKb51YgPeDa4+UVR9WqAq9Xx8BGhXUoQGwzBs9qB9KzO7wNMiH6T35Vu5qhl6JzS5vmfclwKQcbEG2YslIQYGuq2naf0=
Message-ID: <46A47936.1090606@googlemail.com>
Date: Mon, 23 Jul 2007 11:47:34 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>,
       James Smart <James.Smart@emulex.com>, Adrian Bunk <bunk@stusta.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Tilman Schmidt <tilman@imap.cc>,
       linux-ia64@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
       Horms <horms@verge.net.au>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>
Subject: Re: [2/2] 2.6.23-rc1: known regressions
References: <46A477AF.4000309@googlemail.com>
In-Reply-To: <46A477AF.4000309@googlemail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc1.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Andi Kleen                             4
Linus Torvalds                         4
Adrian Bunk                            3
Andrew Morton                          3
Jens Axboe                             3
Al Viro                                2
David Woodhouse                        2
Hugh Dickins                           2
Tejun Heo                              2



SCSI

Subject         : lpfc_sli.c: off-by-10
References      : http://lkml.org/lkml/2007/7/22/284
Last known good : ?
Submitter       : Adrian Bunk <bunk@stusta.de>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



Virtualization

Subject         : 2.6.22-git17 boot failure (XEN)
References      : http://lkml.org/lkml/2007/7/22/266
Last known good : ?
Submitter       : Tilman Schmidt <tilman@imap.cc>
Caused-By       : ?
Handled-By      : ?
Status          : unknown

Subject         : drivers/net/xen-netfront.c: bogus code
References      : http://lkml.org/lkml/2007/7/22/256
Last known good : ?
Submitter       : Adrian Bunk <bunk@stusta.de>
Caused-By       : ?
Handled-By      : Jeremy Fitzhardinge <jeremy@goop.org>
Status          : unknown



IA64

Subject         : Regression in serial console on ia64 after 2.6.22
References      : http://marc.info/?l=linux-ia64&m=118483645914066&w=2
Last known good : ?
Submitter       : Horms <horms@verge.net.au>
Caused-By       : Yinghai Lu <Yinghai.Lu@Sun.COM>
                  commit 18a8bd949d6adb311ea816125ff65050df1f3f6e
Handled-By      : ?
Status          : unknown



Sparc64

Subject         : "build-id" changes break sparc64
References      : http://lkml.org/lkml/2007/7/22/38
Last known good : ?
Submitter       : David Miller <davem@davemloft.net>
Caused-By       : Roland McGrath <roland@redhat.com>
                  commit 18991197b4b588255ccabf472ebc84db7b66a19c
Handled-By      : ?
Status          : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
