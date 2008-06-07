Return-Path: <linux-kernel-owner+w=401wt.eu-S1765378AbYFGBdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765378AbYFGBdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933643AbYFGBak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:30:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933623AbYFGBai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:30:38 -0400
Date: Fri, 6 Jun 2008 18:27:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Chris Wright <chrisw@sous-sol.org>
cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jeff Garzik <jeff@garzik.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
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
In-Reply-To: <20080607010555.470605116@sous-sol.org>
Message-ID: <alpine.LFD.1.10.0806061826420.3473@woody.linux-foundation.org>
References: <20080607010215.358296706@sous-sol.org> <20080607010555.470605116@sous-sol.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 6 Jun 2008, Chris Wright wrote:
>
> -stable review patch.  If anyone has any objections, please let us know.
> ---------------------
> 
> From: Tejun Heo <htejun@gmail.com>
> 
> Inhibiting link PM mode doesn't bring the link back online if it's
> already in powersave mode.  If SRST is used in these cases, libata EH
> thinks that the link is offline and fails detection.  Force hardreset
> if link is in powersave mode.

This isn't upstream. Maybe there's some reason it's not needed upstream, 
but it would be nice to know.

		Linus
