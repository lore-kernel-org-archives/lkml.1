Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbZLQHM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbZLQHM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 02:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942AbZLQHMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 02:12:25 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:46629 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756893AbZLQHMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 02:12:24 -0500
Message-ID: <4B29D9D6.9030702@msgid.tls.msk.ru>
Date: Thu, 17 Dec 2009 10:12:22 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: minyard@acm.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       Martin Wilck <martin.wilck@ts.fujitsu.com>,
       Jean Delvare <jdelvare@suse.de>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH] IPMI: Add parameter to limit CPU usage in kipmid
References: <20091216212354.GA13097@minyard.local> <20091216134252.868ea5bf.akpm@linux-foundation.org>
In-Reply-To: <20091216134252.868ea5bf.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 16 Dec 2009 15:23:54 -0600
> Corey Minyard <minyard@acm.org> wrote:
> 
>> From: Martin Wilck <martin.wilck@ts.fujitsu.com>
>>
>> In some cases kipmid can use a lot of CPU.
> 
> Why is that?  Without this information it is hard for others to suggest
> alternative implementations.

[picking up the thread from the middle]

I dunno why, but I can confirm that kipmid is one of the most
noticeable threads on all machines here running ipmid.

Here's an example from a machine with 20days uptime.
According to `ps -aflx', [kipmid] process took 30:34
sec of CPU time.  Most close to that is [md6_raid1]
thread with 12:30, and next to that is [kjournald]
with 0:24.  30:34 is not exactly huge given 20days
uptime, but it is a clear "winner", far from the
most close competitor.

Different kernels, somewhat different hardware, but
the same behavour.

/mjt
