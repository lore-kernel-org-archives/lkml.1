Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbYFGDOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbYFGDOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 23:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYFGDOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 23:14:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51080 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbYFGDOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 23:14:24 -0400
Message-ID: <4849FD02.9000901@garzik.org>
Date: Fri, 06 Jun 2008 23:14:10 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Tejun Heo <htejun@gmail.com>,
       matthieu.castet@parrot.com, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 10/50] libata: force hardreset if link is in powersave
 mode
References: <20080607010215.358296706@sous-sol.org> <20080607010555.470605116@sous-sol.org> <alpine.LFD.1.10.0806061826420.3473@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806061826420.3473@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 6 Jun 2008, Chris Wright wrote:
>> -stable review patch.  If anyone has any objections, please let us know.
>> ---------------------
>>
>> From: Tejun Heo <htejun@gmail.com>
>>
>> Inhibiting link PM mode doesn't bring the link back online if it's
>> already in powersave mode.  If SRST is used in these cases, libata EH
>> thinks that the link is offline and fails detection.  Force hardreset
>> if link is in powersave mode.
> 
> This isn't upstream. Maybe there's some reason it's not needed upstream, 
> but it would be nice to know.

We do hard reset by default...

	Jeff



