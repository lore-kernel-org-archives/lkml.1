Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbYJOMuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbYJOMuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 08:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYJOMtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 08:49:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39774 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716AbYJOMty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 08:49:54 -0400
Message-ID: <48F5E6D4.8080603@redhat.com>
Date: Wed, 15 Oct 2008 07:49:24 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-ext4@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Possible ext3 corruption with 1K block size
References: <200810150724.42180.arvidjaar@mail.ru>
In-Reply-To: <200810150724.42180.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> There is long standing open bug report on Mandriva which is currently
> beieved to have root cause in file system corruption. It shows itself
> in RPM DB corruption (at least, there is no other known method to trigger
> it). So far all reported cases happened on filesystem with 1K block size
> and stopped when RPM DB was moved to FS with 4K block size.
> 
> There are also similar RH reports as well.
> 
> Here are references:
> 
> https://qa.mandriva.com/show_bug.cgi?id=32547
> 
> This one is rather long. 

yep, unfortunately IIRC most of the bug is "me too's" and "how do I do
the workaround" :)

> Interesting bits are probably around
> 
> https://qa.mandriva.com/show_bug.cgi?id=32547#c177
> https://qa.mandriva.com/show_bug.cgi?id=32547#c148 (many users reporting
> dumpe2fs)
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=230362
> https://bugzilla.redhat.com/show_bug.cgi?id=375931
> https://bugzilla.redhat.com/show_bug.cgi?id=305301
> 
> The Mandriva bugzilla also mentions this mail from Stephen Tweedie 
> http://lkml.org/lkml/2007/9/18/232

I don't think this is related, in the end... there was some possiblity
of corruption from that, but I think it's doubtful it'd hit 1k block
filesystems more, and in any case, the corruption has been seen since
then if I read it right.

> which indicates some issues with 1K blocks, but according to last comment:
> https://qa.mandriva.com/show_bug.cgi?id=32547#c300
> 
> it is still present in 2.6.27 (at least was present on -rc6)
> 
> There was a kernel bug report http://bugzilla.kernel.org/show_bug.cgi?id=11564,
> but in this case it was identified as hardware issue.

My kingdom for a testcase... does anyone have simple steps to reproduce
this?  Or do they all start with "install mandriva on a 1k block size
system?"  :)

-Eric
