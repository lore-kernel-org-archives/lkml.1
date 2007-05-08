Return-Path: <linux-kernel-owner+w=401wt.eu-S1032311AbXEHVTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032311AbXEHVTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032308AbXEHVTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:19:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37044 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032306AbXEHVTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:19:47 -0400
Message-ID: <4640E971.9050400@garzik.org>
Date: Tue, 08 May 2007 17:19:45 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: CodingStyle: start flamewar about use of braces
References: <200705081903.l48J3AOw010373@hera.kernel.org> <20070508124301.17975a4f.randy.dunlap@oracle.com>
In-Reply-To: <20070508124301.17975a4f.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Tue, 8 May 2007 19:03:10 GMT Linux Kernel Mailing List wrote:
> 
>> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e659ba4a0d2d471c0d73590f78e1a1b5a1eede48
>> Commit:     e659ba4a0d2d471c0d73590f78e1a1b5a1eede48
>> Parent:     28be5abb400e5e082f5225105fdc69337ec0c0b4
>> Author:     Oliver Neukum <oliver@neukum.org>
>> AuthorDate: Tue May 8 00:30:34 2007 -0700
>> Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
>> CommitDate: Tue May 8 11:15:12 2007 -0700
>>
>>     CodingStyle: start flamewar about use of braces
> 
> It worked somewhat.  We never did reach any kind of
> concensus about this....
> 
> 
>>     Signed-off-by: Oliver Neukum <oneukum@suse.de>
>>     Cc: Tilman Schmidt <tilman@imap.cc>
>>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>> ---
>>  Documentation/CodingStyle |   15 +++++++++++++++
>>  1 files changed, 15 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
>> index 9069189..e7f5fc6 100644
>> --- a/Documentation/CodingStyle
>> +++ b/Documentation/CodingStyle
>> @@ -160,6 +160,21 @@ supply of new-lines on your screen is not a renewable resource (think
>>  25-line terminal screens here), you have more empty lines to put
>>  comments on.
>>  
>> +Do not unnecessarily use braces where a single statement will do.
>> +
>> +if (condition)
>> +	action();
>> +
>> +This does not apply if one branch of a conditional statement is a single
>> +statement. Use braces in both branches.
>> +
>> +if (condition) {
>> +	do_this();
>> +	do_that();
>> +} else {
>> +	otherwise();
>> +}

If anyone tries to add braces to my code's 'else' statements where they 
are not required, that patch will get NAK'd in a heartbeat.

	Jeff


