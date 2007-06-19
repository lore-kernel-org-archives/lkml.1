Return-Path: <linux-kernel-owner+w=401wt.eu-S1765613AbXFSAL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765613AbXFSAL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 20:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762336AbXFSALT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 20:11:19 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:12873 "EHLO
	outbound7-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755559AbXFSALS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 20:11:18 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <46771F9F.40608@am.sony.com>
Date: Mon, 18 Jun 2007 17:13:19 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Gerrit Huizenga <gh@us.ibm.com>
CC: holzheu@linux.vnet.ibm.com, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, gregkh@suse.de, mtk-manpages@gmx.net,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       "lf_kernel_messages@linux-foundation.org" 
	<lf_kernel_messages@linux-foundation.org>
Subject: Re: [RFC/PATCH] Documentation of kernel messages
References: <E1HzGkR-0008DO-Un@w-gerrit.beaverton.ibm.com>
In-Reply-To: <E1HzGkR-0008DO-Un@w-gerrit.beaverton.ibm.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Jun 2007 00:10:51.0209 (UTC) FILETIME=[4BA65B90:01C7B206]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerrit Huizenga wrote:
> Further, yet another kernel config option could allow distros to output
> the calculated MD5 sum to be printed, much like we do with timestamps
> today.

> Comments?

Would the compiled-in text then also become replaceable?
Or is the MD5 sum output expected to be in addition to
the regular English message?

If message replacement at compile-time is supported, this
could allow for creating "short" versions of the messages,
which could have a beneficial impact on kernel size.

Right now, it is possible to completely disable printks
and re-claim about 100K of memory.  However, in some
embedded configurations, even if you are space-constrained
it's desirable to retain some of the printks, for in-field
debugging.  Thus not very many embedded developers
disable printks completely, even though the option has
been supported for a while.  (That, and many aren't caught
up to the kernel version where it was introduced (2.6.10) :-)

But compressed messages (shortened text through abbreviations,
or just outputting the ID alone, etc.) could save SOME
of the space, in trade for less readability.  Heck, just
removing all vowels would probably save 10k, and not
hurt readability that much.

Finally, for testing, it's handy to also
have automatic translation generators.
At a former company I worked for, they had translators
that would output:
 * all messages shortened by 20%
 * all messages lengthened by 20%
 * every message converted to pig-latin

These were mostly used for testing if the strings broke
screen real-estate constraints (which don't apply to
kernel messages).  But the automatic translators
would sometimes catch messages with weird attributes.

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

