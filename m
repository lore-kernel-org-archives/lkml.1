Return-Path: <linux-kernel-owner+w=401wt.eu-S1030559AbXAaTZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030559AbXAaTZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 14:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030557AbXAaTZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 14:25:13 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:44125 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030559AbXAaTZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 14:25:11 -0500
Date: Wed, 31 Jan 2007 20:20:48 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
cc: Adrian Bunk <bunk@stusta.de>, Andi Kleen <ak@suse.de>,
       Greg KH <greg@kroah.com>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Rewriting floppy.c was Re: Free Linux Driver Development!
In-Reply-To: <20070131185819.GH7584@csclub.uwaterloo.ca>
Message-ID: <Pine.LNX.4.61.0701312009460.13737@yvahk01.tjqt.qr>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>
 <20070130191020.GF20642@kroah.com> <20070131011340.GP3754@stusta.de>
 <20070131012428.GA31759@kroah.com> <p7364anpkz5.fsf_-_@bingen.suse.de>
 <20070131172410.GV3754@stusta.de> <Pine.LNX.4.61.0701311920110.13737@yvahk01.tjqt.qr>
 <20070131185819.GH7584@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 31 2007 13:58, Lennart Sorensen wrote:
>On Wed, Jan 31, 2007 at 07:24:54PM +0100, Jan Engelhardt wrote:
>> How much different hardware does the (old)floppy.c do? I imagine that
>> today, where floppies phase out, there will be, in descending order:
>> 
>>  * USB floppy drives (atm handled by sd.c, could be better to have sf.c)
>>  * FDCs on mainboards
>>  * 1.44M drives
>>  * 1.2M drives
>> 
>> Even a working 2.88M, as cool as it sounds, never landed in my hands ever
>> since I've been into computing. Perhaps the oldest, smallest disk I once
>> had was a 360K 5.25", but the B floppy drive to read it was already
>> multi-compliant that read up to 1.2M disks.
>
>So what is wrong with the current floppy driver (other than being 120k
>of code apparently)?

>From my standpoint, nothing. Developers knowing it better might disagree.
(It looks a little ugly, but well, it worked last time I tried.)

>As for floppies that should work, well I imagine on x86 that would have
>to be 360k and 1200k 5-1/4", and 720k, 1200k and 1440k 3-1/2".  Would
>perhaps be nice to still support 160, 180 and 320k on the 5-1/4" drive
>too just in case anyone ever wants to read one.  Of course some people

Do the special formats (entries 9, 12, 13, 16, 17 in floppy.c)
even cost something more than their line in that struct?

>might also want support for the higher capacity formats on the 1440k

Note that I was able to format a floppy with 1680k [21 spt] once under
Linux (including using it). No other OS (including the BIOS) could do
something with it though, and it had to be accessed explicitly through
/dev/fd0u1680. Maybe also the 1760k [22 spt] one, but can't remember.

With regular "1.44M" disks you get in any store, to be noted.

I'm glad to still have a 5.25" drive buried in a 386 [linux 2.6.13] :=)




Jan
-- 
ft: http://freshmeat.net/p/chaostables/
