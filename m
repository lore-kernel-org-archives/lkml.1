Return-Path: <linux-kernel-owner+w=401wt.eu-S1030827AbXCTFPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030827AbXCTFPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 01:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934019AbXCTFPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 01:15:17 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:52775 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934017AbXCTFPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 01:15:15 -0400
Date: Tue, 20 Mar 2007 01:15:02 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch 00/31] 2.6.20-stable review
In-reply-to: <20070319213647.GB9261@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Message-id: <200703200115.05861.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20070319213647.GB9261@kroah.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 March 2007, Greg KH wrote:
>This is the start of the stable review cycle for the 2.6.20.4 release.
>There are 31 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let us know.  If anyone is a maintainer of the proper subsystem, and
>wants to add a Signed-off-by: line to the patch, please respond with it.
>
>These patches are sent out with a number of different people on the
>Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
>to add your name to the list.  If you want to be off the reviewer list,
>also email us.
>
>Responses should be made by Thursday March, 22, 15:00:00 UTC.
>Anything received after that time might be too late.

BINGO!  One of these 31 patches may be the guilty party that's playing
tricks with tar's mind.  I'm running 2.6.20.4-rc1 on an older athlon 
xp2800 with a gig of ram.

Amanda has gotten through the estimate phase and is now doing the backup.  
It will fail, out of tape.  Here is an amstatus output as its running 
right now.

coyote:/GenesAmandaHelper-0.5 3 planner: [dumps way too big, 350850 KB, must skip incremental dumps]
coyote:/GenesAmandaHelper-0.6 1 planner: [dumps way too big, 184977 KB, must skip incremental dumps]
coyote:/bin                   1 planner: [dumps way too big, 1110 KB, must skip incremental dumps]
coyote:/boot                  1        3m wait for dumping
coyote:/dev                   1 planner: [dumps way too big, 290 KB, must skip incremental dumps]
coyote:/etc                   1 planner: [dumps way too big, 18291 KB, must skip incremental dumps]
coyote:/home                  0     1018m wait for dumping
coyote:/lib                   3 planner: [dumps way too big, 11705 KB, must skip incremental dumps]
coyote:/opt                   1        5m wait for dumping
coyote:/root                  3 planner: [dumps way too big, 785963 KB, must skip incremental dumps]
coyote:/sbin                  1 planner: [dumps way too big, 10 KB, must skip incremental dumps]
coyote:/tmp                   4       32m wait for dumping
coyote:/usr/X11R6             1        2m wait for dumping
coyote:/usr/bin               1 planner: [dumps way too big, 339170 KB, must skip incremental dumps]
coyote:/usr/dlds              1 planner: [dumps way too big, 2140 KB, must skip incremental dumps]
coyote:/usr/dlds-misc         3        0m wait for dumping
coyote:/usr/dlds-rpms         1 planner: [dumps way too big, 3130 KB, must skip incremental dumps]
coyote:/usr/dlds-tgzs         1 planner: [dumps way too big, 10 KB, must skip incremental dumps]
coyote:/usr/games             0        0m wait for dumping
coyote:/usr/include           1 planner: [dumps way too big, 10557 KB, must skip incremental dumps]
coyote:/usr/kerberos          1        0m wait for dumping
coyote:/usr/lib               1 planner: [dumps way too big, 474409 KB, must skip incremental dumps]
coyote:/usr/libexec           2 planner: [dumps way too big, 11285 KB, must skip incremental dumps]
coyote:/usr/local             2      279m wait for dumping
coyote:/usr/man               1        0m wait for dumping
coyote:/usr/movies            2     7271m dumping     5485m ( 75.44%) (0:12:47)
coyote:/usr/music             1 planner: [dumps way too big, 2448290 KB, must skip incremental dumps]
coyote:/usr/pix               2       17m wait for dumping
coyote:/usr/sbin              1 planner: [dumps way too big, 3254 KB, must skip incremental dumps]
coyote:/usr/share             3 planner: [dumps way too big, 40514 KB, must skip incremental dumps]
coyote:/usr/src               3     6822m wait for dumping
coyote:/var                   1      366m wait for dumping

SUMMARY          part      real  estimated
                           size       size
partition       :  32
estimated       :  32                31973m
flush           :   0         0m
failed          :  18                16155m           ( 50.53%)
wait for dumping:  13                 8547m           ( 26.73%)
dumping to tape :   0                    0m           (  0.00%)
dumping         :   1      5485m      7271m ( 75.44%) ( 17.16%)
dumped          :   0         0m         0m (  0.00%) (  0.00%)
wait for writing:   0         0m         0m (  0.00%) (  0.00%)
wait to flush   :   0         0m         0m (100.00%) (  0.00%)
writing to tape :   0         0m         0m (  0.00%) (  0.00%)
failed to tape  :   0         0m         0m (  0.00%) (  0.00%)
taped           :   0         0m         0m (  0.00%) (  0.00%)
  tape 1        :   0         0m         0m (  0.00%) Dailys-19
8 dumpers idle  : not-idle
taper idle
network free kps:      6800
holding space   :     71118m (100.00%)
 dumper0 busy   :  0:00:00  (  0.00%)
 0 dumpers busy :  0:00:00  (  0.00%)
 1 dumper busy  :  0:00:00  (  0.00%)
----------------
The directory shown on line one of this report actually has:
[root@coyote /]# du -h /GenesAmandaHelper-0.5/
1.6G    /GenesAmandaHelper-0.5/config-bak
1.6G    /GenesAmandaHelper-0.5/

But line one above says its 350850 KB. 351 MB.  That directory and its 
contents have not been touched in at least a week, March 7th TBE and had 
766MB in it the last time I looked.  So a level 3 backup should be a very 
sparsely filled 65k directory list.

Then, looking at line 2, that tree is virtually identical and generally 
contains the same, or a few percentage points more data due to a change in 
the starting point of one of the amanda trees I'm doing external to 
amanda, so it may contain as much as 800MB right now.  As this is an 
active directory, with 20 megs or so new each night, I could believe a 
level 1 being 21MB maybe, certainly no more.  The last level 1 under a 
good kernel was 19MB according to the emails amanda sends me.  But it 
wants to backup 185MB tonight?

Now we are a little closer to finding this problem.  Or should I say this, 
because if I'm booted to either a working 2.6.20* kernel, or to one of the 
4 2.6.21-rc's I've tested, the data returned by a du -h is sane.  The 
figure I pasted in for the line 1 argument above is not, it's nearly 
double the actual size of that particular directory.  So it's conceivable 
that there are 2 problems as this is the first time a du -h has been 
effected too.

In any event, something tickled the monster, and its hungry.  This is a 
full-stop, show-stopper AFAIAC.

I'll cut that patch-2.6.20.4-rc1 in halves, and build 2 more test 
kernels tomorrow to start a bisect if no one has any better idea 
before then.

But its getting sleepy out now.

Thanks all.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
There is an order of things in this universe.
		-- Apollo, "Who Mourns for Adonais?" stardate 3468.1
