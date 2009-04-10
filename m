Return-Path: <linux-kernel-owner+w=401wt.eu-S936810AbZDJMqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936810AbZDJMqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbZDJMqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:46:44 -0400
Received: from mail.tmr.com ([64.65.253.246]:56284 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849AbZDJMqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:46:43 -0400
Message-ID: <49DF3FA5.30705@tmr.com>
Date: Fri, 10 Apr 2009 08:46:29 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090328 Fedora/1.1.15-3.fc9 SeaMonkey/1.1.15
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Bill Davidsen <davidsen@tmr.com>,
       linux-kernel@vger.kernel.org, Corrado Zoccolo <czoccolo@gmail.com>,
       =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>,
       Jan Knutar <jk-lkml@sci.fi>
Subject: Re: SSD and IO schedulers
References: <4dcf7d360901301355l7ed26a5aob7ef6d79d9607b6b@mail.gmail.com> <20090204004003.26068f72@werewolf.home> <200902071858.40146.jk-lkml@sci.fi> <4e5e476b0904081218i29871702qc8bacb680c51ec2c@mail.gmail.com> <20090408195610.GA5447@fancy-poultry.org> <49DE8B30.3080208@tmr.com> <20090410055725.GC10557@mit.edu>
In-Reply-To: <20090410055725.GC10557@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Thu, Apr 09, 2009 at 07:56:32PM -0400, Bill Davidsen wrote:
>   
>> This is good information, and if I ever configure a netbook for run 
>> fsync-tester I shall avoid the DL scheduler. ;-(
>>
>> However... this test, and several others designed to find the ultimate  
>> performance limits of disk io, don't mimic any typical use of most 
>> desktops and virtually all netbooks.
>>
>> Is there a benchmark which would return so useful data for typical use, 
>> doing some mail, some browsing, and maybe some light presentation, 
>> spreadsheet, or word processing. None of those uses are likely to 
>> generate this level of io, this file size, etc. The number of users is 
>> one, it's not used as a server, and probably most of the tuning done (if 
>> any) is aimed at battery life rather than blinding speed with a three 
>> digit load average.
>>     
>
> As long as you don't believe a netbook user will ever try to type an
> e-mail using a mail reader like alpine (which is what Linus uses),
> while running "yum update" in the background, sure.  But if you don't
> think that is a normal use case, I'll let you argue with Linus on that
> score.  In any case, the big-file-write-and-flush plus fsync-tester
> was designed to roughly replicate this scenario which Linus saw on his
> desktop system.
>   

I almost fell out of my chair reading this, because I was doing exactly 
what you describe, applying the latest Fedora 9  security stuff and 
reading mail. The difference is that I'm not on a netbook, with a puny 
CPU, small memory and 5400 rpm drive, but a VM running on a host with 
multi-core, 8GB RAM, and a raid array of fast TB drives. The way I would 
use a netbook would be as a glorified PDA, and I still feel that a 
useful benchmark should duplicate the typical use, rather than some case 
which occurs a few times a month, unless that case is the critical load 
and justified less optimal performance the majority of the time.

Thanks for the history lesson, but I want my netbook to handle best the 
stuff I do most. If the modified scheduler performed better when I am 
reading mail and need to open a spreadsheet attachment, I'd certainly 
prefer that. Whether I'd bother to build my own patched kernel would 
depend on how "faster" it ran, I'm reasonably happy with the way that 
runs on what I have.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


