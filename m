Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbXJHCcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbXJHCcj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 22:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbXJHCcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 22:32:31 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43501 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752475AbXJHCcb (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 22:32:31 -0400
Date: Mon, 08 Oct 2007 12:32:30 +1000
To: "Max Waterman" <davidmaxwaterman+kernel@fastmail.co.uk>,
       "David Chinner" <dgc@sgi.com>
Subject: Re: XFS internal error
From: "Barry Naujok" <bnaujok@sgi.com>
Organization: SGI
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
MIME-Version: 1.0
References: <470831E6.4030704@fastmail.co.uk> <20071008001452.GX995458@sgi.com> <47098DD4.4090207@fastmail.co.uk>
Content-Transfer-Encoding: 7bit
Message-ID: <op.tzuxcgsi3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <47098DD4.4090207@fastmail.co.uk>
User-Agent: Opera Mail/9.10 (Win32)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Oct 2007 11:54:28 +1000, Max Waterman  
<davidmaxwaterman+kernel@fastmail.co.uk> wrote:

> David Chinner wrote:
>> I suggest that you run xfs_check on the filesystem and if that
>> shows up errors, run xfs_repair onteh filesystem to correct them.
>>
> It did, and I did, and another xfs_check produced no output.
>
> Do I need to do anything else to correct it? xfs_repair produced a whole  
> bunch of stuff that I don't understand...this is the bit that looks most  
> significant :
>
>> Phase 6 - check inode connectivity...
>>         - resetting contents of realtime bitmap and summary inodes
>>         - traversing filesystem ...
>> can't read freespace block 16777216 for directory inode 2095141277
>> rebuilding directory inode 2095141277
>> free block 16777216 for directory inode 2100841732 bad nused
>> rebuilding directory inode 2100841732
>> free block 16777216 for directory inode 2102199514 bad nused
>> rebuilding directory inode 2102199514
>> free block 16777216 for directory inode 2102200124 bad nused
>> rebuilding directory inode 2102200124
>> free block 16777216 for directory inode 2102905843 bad nused
>> rebuilding directory inode 2102905843
>> free block 16777216 for directory inode 3277510927 bad nused
>> rebuilding directory inode 3277510927
>> free block 16777216 for directory inode 3277524487 bad nused
>> rebuilding directory inode 3277524487
>> free block 16777216 for directory inode 3379886019 bad nused
>> rebuilding directory inode 3379886019
>>         - traversal finished ...
>>         - moving disconnected inodes to lost+found ...
> That last line looks suspicious...furthermore, when I mount the  
> filesystem, I don't see a 'lost+found' directory (which I've been used  
> to seeing on IRIX). Ah, perhaps the '...' with *nothing* after it means  
> it didn't do any moving. Am I right?

Yes, the latest xfs_repair doesn't create a lost+found unless it
needs to, and if it does so, it will list the inodes moved there.

So, in your case, nothing went to lost+found.

Regards,
Barry.

