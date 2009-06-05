Return-Path: <linux-kernel-owner+w=401wt.eu-S1755051AbZFEWCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbZFEWCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 18:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbZFEWCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 18:02:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33871 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbZFEWCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 18:02:31 -0400
Message-ID: <4A2995F4.8050901@redhat.com>
Date: Fri, 05 Jun 2009 17:02:28 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: Aioanei Rares <krnl.list@gmail.com>, linux-ext4@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Mild filesystem corruption on ext4 (no journal)
References: <4A28F83F.4030704@tuffmail.co.uk> <4A292E61.3050204@gmail.com> <4A293084.5010400@tuffmail.co.uk> <4A2937CC.7070503@redhat.com> <4A294B15.9070209@tuffmail.co.uk> <4A29601F.3070802@redhat.com> <4A298EF5.9000504@tuffmail.co.uk>
In-Reply-To: <4A298EF5.9000504@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Eric Sandeen wrote:
>> Alan Jenkins wrote:

...

>> And did the reread after dropping caches have the right data?
>>   
> 
> Yes.
> 
>> Did the block numbers reported by filefrag -v change post-boot?
>>   
> 
> Oh, I didn't understand that's what you were asking for.

Yeah, after I saw that bug it does seem to be solely a data flushing
issue.  I was trying the testcase and looking at what is on-disk in the
original image, what's on-disk after the unmount, and what is seen in
the chroot, for the file in question.... 3 different answers.

(and oddly enough dropping caches doesn't show it; you have to
unmount/remount)

-Eric

