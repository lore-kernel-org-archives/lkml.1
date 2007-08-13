Return-Path: <linux-kernel-owner+w=401wt.eu-S1033008AbXHMSTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033008AbXHMSTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032593AbXHMSA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:00:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:24235 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032344AbXHMSAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:00:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=IUVknz5q2glMm4rszwZlYykg1u48GcgbCjS7i0uX3S/rYLq7RphxJjsguQJN1MU62m/D50V+cJKSHfJ4jjyTEb9ol+0XeDkSIk9K6+qySg5Jp2vhwqs8Dux+GxzEI4dF7wVRwqqWQSyaqYB1wLCHjVjmE95U5sR/u6n6t5X1T1k=
Message-ID: <46C09C11.3070105@googlemail.com>
Date: Mon, 13 Aug 2007 19:59:45 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>, Tino Keitel <tino.keitel@gmx.de>,
       "Stuart_Hayes@Dell.com" <Stuart_Hayes@Dell.com>,
       Daniel Exner <dex@dragonslave.de>, kvm-devel@lists.sourceforge.net,
       Avi Kivity <avi@qumranet.com>, Paolo Ornati <ornati@fastwebnet.it>,
       linux-alpha@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Oliver Falk <oliver@linux-kernel.at>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Clayton <andrew@digital-domain.net>
Subject: Re: [4/4] 2.6.23-rc3: known regressions
References: <46C098FD.1030601@googlemail.com>
In-Reply-To: <46C098FD.1030601@googlemail.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.23-rc3.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Adrian Bunk                            9
Andi Kleen                             5
Linus Torvalds                         5
Andrew Morton                          4
Al Viro                                3
Cornelia Huck                          3
Jens Axboe                             3
Tejun Heo                              3



FS

Subject         : [NFSD OOPS] 2.6.23-rc1-git10
References      : http://lkml.org/lkml/2007/8/2/462
Last known good : ?
Submitter       : Andrew Clayton <andrew@digital-domain.net>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



USB

Subject         : EHCI Regression in 2.6.23-rc2
References      : http://lkml.org/lkml/2007/8/10/81
Last known good : ?
Submitter       : Daniel Exner <dex@dragonslave.de>
Caused-By       : Stuart_Hayes@Dell.com <Stuart_Hayes@Dell.com>
                  commit 196705c9bbc03540429b0f7cf9ee35c2f928a534
Handled-By      : ?
Status          : unknown

Subject         : 2.6.23-rc1: USB hard disk broken
References      : http://lkml.org/lkml/2007/7/25/62
Last known good : ?
Submitter       : Tino Keitel <tino.keitel@gmx.de>
Caused-By       : ?
Handled-By      : Oliver Neukum <oliver@neukum.org>
Status          : unknown



Virtualization

Subject         : WARNING: at arch/x86_64/kernel/smp.c:379 smp_call_function_single()
References      : http://lkml.org/lkml/2007/8/10/117
Last known good : ?
Submitter       : Paolo Ornati <ornati@fastwebnet.it>
Caused-By       : Avi Kivity <avi@qumranet.com>
                  commit cec9ad279b66793bee0b5009b7ca311060061efd
Handled-By      : Avi Kivity <avi@qumranet.com>
Status          : problem is being debugged



Alpha

Subject         : -Werror compilation problem - make[1]: *** [arch/alpha/kernel/sys_titan.o] Error 1
References      : http://lkml.org/lkml/2007/8/6/137
Last known good : ?
Submitter       : Oliver Falk <oliver@linux-kernel.at>
Caused-By       : ?
Handled-By      : ?
Status          : unknown



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
