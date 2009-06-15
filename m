Return-Path: <linux-kernel-owner+w=401wt.eu-S1764883AbZFOR65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764883AbZFOR65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758562AbZFOR6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:58:47 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:5580 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZFOR6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:58:46 -0400
X-SpamScore: -35
X-BigFish: VPS-35(zz1418M1432R98dR1805M1b0bMzz1202hzzz2fh17ch6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4A368BC8.3010006@am.sony.com>
Date: Mon, 15 Jun 2009 10:58:32 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Marco <marco.stornelli@gmail.com>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
References: <4A33A7A2.1050608@gmail.com> <4A3681C2.5010508@am.sony.com> <4A36887C.1050906@gmail.com>
In-Reply-To: <4A36887C.1050906@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2009 17:58:33.0281 (UTC) FILETIME=[E5EF0B10:01C9EDE2]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marco wrote:
> Tim Bird wrote:
>> Marco wrote:
>>> This is a second attempt at mainlining Pramfs. The first attempt was
>>> back in early 2004 by MontaVista. Since then the kernel code has almost
>>> been completely rewritten. So my first item on the list was porting the
>>> code on a recent kernel version. After that I added the XIP support.
>> It's very nice to see this technology revived.
>>
>> Is the information at:
>> http://pramfs.sourceforge.net/
>> and
>> http://pramfs.sourceforge.net/pramfs-spec.html
>> still valid - particularly the latter?
> 
> Yep. at 99%. I've done some modifications due to the porting and there
> will be some ones due to this review. I tried to talk with Steve
> Longerbeam to update the site but without success. I'd like to update it.
> 
>> It would be very nice to see this get mainlined.  I believe that
>> one of the main uses for this is to store crash information
>> over a reboot so the next kernel (not in crashing state) can have
>> a better chance of dealing with it.  As such, I think
>> it's important to keep the code paths for Pramfs short, synchronous,
>> and unentangled with other kernel systems (block IO, page cache, etc.).
>>
> 
> Yes, I quite agree. I think that this kind of feature would be very
> useful especially for the embedded world.

Just FYI - we have an "exception monitor" at Sony
which is used in several projects, that records application and
kernel crash information into the file system, for subsequent
(often in-field) analysis.  However, the data currently gets written
to a flash filesystem and the logs sometimes get truncated or otherwise
corrupted.  This seems like a perfect match for what we're trying
to do.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

