Return-Path: <linux-kernel-owner+w=401wt.eu-S1764016AbZFORQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764016AbZFORQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762194AbZFORQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:16:15 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:25101
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752019AbZFORQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:16:12 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zz98dR4015Lzz1202hzzz2fh6bh17ch61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
Message-ID: <4A3681C2.5010508@am.sony.com>
Date: Mon, 15 Jun 2009 10:15:46 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Marco <marco.stornelli@gmail.com>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
References: <4A33A7A2.1050608@gmail.com>
In-Reply-To: <4A33A7A2.1050608@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2009 17:15:48.0281 (UTC) FILETIME=[ED131A90:01C9EDDC]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco wrote:
> This is a second attempt at mainlining Pramfs. The first attempt was
> back in early 2004 by MontaVista. Since then the kernel code has almost
> been completely rewritten. So my first item on the list was porting the
> code on a recent kernel version. After that I added the XIP support.

It's very nice to see this technology revived.

Is the information at:
http://pramfs.sourceforge.net/
and
http://pramfs.sourceforge.net/pramfs-spec.html
still valid - particularly the latter?

It would be very nice to see this get mainlined.  I believe that
one of the main uses for this is to store crash information
over a reboot so the next kernel (not in crashing state) can have
a better chance of dealing with it.  As such, I think
it's important to keep the code paths for Pramfs short, synchronous,
and unentangled with other kernel systems (block IO, page cache, etc.).

Thanks,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

