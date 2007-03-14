Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbXCNDcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbXCNDcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 23:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbXCNDcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 23:32:04 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:62774 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXCNDcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 23:32:03 -0400
Date: Tue, 13 Mar 2007 23:31:53 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: New thread RDSL, post-2.6.20 kernels and amanda (tar) miss-fires
In-reply-to: <200703131436.33509.gene.heskett@gmail.com>
To: linux-kernel@vger.kernel.org
Message-id: <200703132331.56140.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703130428.11014.gene.heskett@gmail.com>
 <200703131436.33509.gene.heskett@gmail.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 March 2007, Gene Heskett wrote:
>On Tuesday 13 March 2007, Gene Heskett wrote:
>>Greetings;
>>Someone suggested a fresh thread for this.
>>
>>I now have my scripts more or less under control, and I can report that
>>kernel-2.6.20.1 with no other patches does not exhibit the undesirable
>>behaviour where tar thinks its all new, even when told to do a level 2
>> on a directory tree that hasn't been touched in months to update
>> anything.
>>
>>Next up, 2.6.20.2, plain and with the latest RDSL-0.30 patch.
>
>And amanda/tar worked normally for 2.6.20.2 plain.
>
>Next up, 2.6.21-rc1 if it will build here.

It built, it booted, and its busted big time.  First, with an amdump 
running in the background, the machine is so close to unusable that I 
considered rebooting, but I needed the data to show the problem.  I am 
losing the keyboard and mouse for a minute or more at a time but the 
keystrokes seem to be being registered so it eventually catches up.

Disk i/o seems to be the killer according to gkrellm.

But to give one an idea of the fits this is giving tar, I'll snip a line 
or 2 from an amstatus report here:
coyote:/GenesAmandaHelper-0.6 1 planner: [dumps way too big, 138200 KB, 
must skip incremental dumps]

Huh?  138.2GB?  A 'du -h .' in that dir says 766megs.

coyote:/root                  1     4426m wait for dumping
du -h says 5.0GB so that's ballpark, but its also a level 1, so maybe 20 
megs is actually new since 15:57 this afternoon local.  kmails final 
maildir is in that dir.

This goes on for much of the amstatus report, very few of the reported 
sizes are close to sane.

Now, can someone suggest a patch I can revert that might fix this?  The 
total number of patches between 2.6.20 and 2.6.21-rc1 will have me 
building kernels to bisect this till the middle of June at this rate.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Is a tattoo real, like a curb or a battleship?  Or are we suffering in 
Safeway?
