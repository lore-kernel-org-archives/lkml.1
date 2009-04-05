Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbZDEDql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbZDEDql (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 23:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757041AbZDEDqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 23:46:32 -0400
Received: from rtr.ca ([76.10.145.34]:57941 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278AbZDEDqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 23:46:31 -0400
Message-ID: <49D82993.8050208@rtr.ca>
Date: Sat, 04 Apr 2009 23:46:27 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: David Newall <davidn@davidnewall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Garzik <jeff@garzik.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       torvalds@linux-foundation.org, tytso@mit.edu, drees76@gmail.com,
       jesper@krogh.cc, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>	<20090326171148.9bf8f1ec.akpm@linux-foundation.org>	<alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>	<20090326174704.cd36bf7b.akpm@linux-foundation.org>	<alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>	<20090326182519.d576d703.akpm@linux-foundation.org>	<20090401210337.GB3797@csclub.uwaterloo.ca>	<20090401143622.b1885643.akpm@linux-foundation.org>	<20090401225737.GC3797@csclub.uwaterloo.ca>	<49D6214A.9030204@rtr.ca>	<20090403151648.GJ3795@csclub.uwaterloo.ca>	<49D65C80.4080003@garzik.org> <20090404011838.9c39a78a.akpm@linux-foundation.org> <49D8100F.1060504@davidnewall.com>
In-Reply-To: <49D8100F.1060504@davidnewall.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall wrote:
> Andrew Morton wrote:
>> - open the file
>>
>> - unlink the file
>>
>> - now sit in a loop, slowly nibbling away at the tail with
>>   ftruncate() until the file is gone.
> 
> Why not fork and unlink in the child?
..

I think it does the equivalent of that today.

Problem is, if you do the unlink without the nibbling,
then the disk locks up the system cold for 2-3 minutes
until the disk delete actually completes.

-ml
