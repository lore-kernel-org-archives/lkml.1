Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbXCLUYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbXCLUYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbXCLUYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:24:18 -0400
Received: from vms048pub.verizon.net ([206.46.252.48]:60263 "EHLO
	vms048pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbXCLUYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:24:17 -0400
Date: Mon, 12 Mar 2007 16:24:11 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: RSDL for 2.6.21-rc3- 0.29
In-reply-to: <20070312195436.GA15319@oscar.prima.de>
To: linux-kernel@vger.kernel.org
Cc: Patrick Mau <mau@oscar.ping.de>, Douglas McNaught <doug@mcnaught.org>
Message-id: <200703121624.11417.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20070311013506.GD10459@waste.org>
 <87slcajliq.fsf@suzuka.mcnaught.org> <20070312195436.GA15319@oscar.prima.de>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 March 2007, Patrick Mau wrote:
>On Mon, Mar 12, 2007 at 03:43:09PM -0400, Douglas McNaught wrote:
>> Gene Heskett <gene.heskett@gmail.com> writes:
>> > On Monday 12 March 2007, Douglas McNaught wrote:
>> >>Gene Heskett <gene.heskett@gmail.com> writes:
>> >>> I'd considered it, but with 32 dle entries, the whole strace
>> >>> output would be terrabytes & I don't have THAT much disk.  Not to
>> >>> mention it traces only the parent process, so tar would be merrily
>> >>> marching along to its own drummer and not traced I'm  afraid.
>> >>
>> >>$ strace -ff
>> >>
>> >>-Doug
>> >
>> > Someone else suggested the single -f, and I tried that, but even
>> > with the shell history set for 100,000 lines, i can't get back to
>> > the start, and I think its mucking with the shell arguments
>> > numbering as what I can see is about 5 reads through /etc/services
>> > accompanied by endless complaints of -EBADFD, the the logfile it
>> > generates says the port it was given was rejected when amcheck was
>> > run, here is that snip:
>>
>> I'd do 'strace -ff -o /tmp/amanda-strace <command>', which will give
>> you a set of files in /tmp, one for each PID created by fork().  Then
>> find the one that has the 'tar' invocation you're looking for.
>
>Hi,
>
>I hope you don't mind me jumping in ...
>
>Why not temporarly replace "/bin/tar" with a shell script that does:
>
>#!/bin/sh
>exec strace -f -o output /bin/real.tar $@
>
>That should be working, shouldn't it ?
>
>Cheers,
>Patrick

It should I'd think, for those instances where these scripts are run by 
hand and therefore have a shell to output to.  I'll give that a try when 
I get my script problem resolved, its a basic diff in the operation of 
real tapes and vtapes I need to get right for both scenarios.

Good Idea(TM), Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"Ignorance is the soil in which belief in miracles grows."
-- Robert G. Ingersoll
