Return-Path: <linux-kernel-owner+w=401wt.eu-S937308AbZDIX4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937308AbZDIX4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761563AbZDIX4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:56:43 -0400
Received: from mail.tmr.com ([64.65.253.246]:37088 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611AbZDIX4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:56:43 -0400
Message-ID: <49DE8B30.3080208@tmr.com>
Date: Thu, 09 Apr 2009 19:56:32 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090328 Fedora/1.1.15-3.fc9 SeaMonkey/1.1.15
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: linux-kernel@vger.kernel.org, Corrado Zoccolo <czoccolo@gmail.com>,
       =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>,
       Jan Knutar <jk-lkml@sci.fi>
Subject: Re: SSD and IO schedulers
References: <4dcf7d360901301355l7ed26a5aob7ef6d79d9607b6b@mail.gmail.com> <20090204004003.26068f72@werewolf.home> <200902071858.40146.jk-lkml@sci.fi> <4e5e476b0904081218i29871702qc8bacb680c51ec2c@mail.gmail.com> <20090408195610.GA5447@fancy-poultry.org>
In-Reply-To: <20090408195610.GA5447@fancy-poultry.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heinz Diehl wrote:
> On 08.04.2009, Corrado Zoccolo wrote: 
> 
>> I found that elevator=deadline performs much better than noop for
>> writes, and almost as well for reads
> [....]
> 
> The DL elevator has slightly more throughput than cfq and anticipatory,
> but is almost unusuable under load.
> 
> Running Theodore Ts'os "fsync-tester" while doing Linus' torture test 
> "while : ; do time sh -c "dd if=/dev/zero of=bigfile bs=8M count=256 ; sync; rm bigfile"; done"
> shows it clearly:
> 
This is good information, and if I ever configure a netbook for run fsync-tester 
I shall avoid the DL scheduler. ;-(

However... this test, and several others designed to find the ultimate 
performance limits of disk io, don't mimic any typical use of most desktops and 
virtually all netbooks.

Is there a benchmark which would return so useful data for typical use, doing 
some mail, some browsing, and maybe some light presentation, spreadsheet, or 
word processing. None of those uses are likely to generate this level of io, 
this file size, etc. The number of users is one, it's not used as a server, and 
probably most of the tuning done (if any) is aimed at battery life rather than 
blinding speed with a three digit load average.

I don't think this is a useful benchmark for netbooks, and hopefully there is a 
test available which will give more insight into the performance in typical use.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
