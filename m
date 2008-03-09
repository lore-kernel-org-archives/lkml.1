Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbYCISGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbYCISGO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 14:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbYCISGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 14:06:03 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:47495 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798AbYCISGC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 14:06:02 -0400
Date: Sun, 9 Mar 2008 19:05:53 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Eric Sandeen <sandeen@sandeen.net>
cc: David Chinner <dgc@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com
Subject: Re: 2.6.25-rc hangs
In-Reply-To: <47D413FA.50602@sandeen.net>
Message-ID: <alpine.DEB.1.00.0803091858480.5349@sheep.housecafe.de>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <20080307224040.GV155259@sgi.com> <alpine.DEB.1.00.0803080032020.7723@sheep.housecafe.de> <alpine.DEB.1.00.0803080251110.4325@sheep.housecafe.de> <alpine.DEB.1.00.0803090658040.5349@sheep.housecafe.de>
 <47D413FA.50602@sandeen.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008, Eric Sandeen wrote:
>> I tried to follow the git-bisect manpage (and have successfully used
>> bisect in the past a few times), but I think ~5700 revisions between
>> 2.6.24 and 2.6.25 are just too much fuzz. The bisect logs so far, with
>> my comments inbetween:
>
> Christian, what is the test you are using for the bisect?

Sorry, I don't understand: which "test" do you mean?

I did the bisect as per the bisect log and then just rebooted. Which gave 
me no usable results yet. I'm trying to boot 2.6.25-rc1 in a few moments 
and see if the hang is there as well. If it is, I'll start bisecting again 
and hope that "halfway between -rc1 and .24" will be a bootable kernel 
this time...

The "error" I'm trying to chase is a system "hang", but no instant lockup. 
I can reproduce this by increasing disk I/O. I did this primarily with 
rsync from different filesystems to my backup XFS partition. After a few 
minutes, the INFO: messages[0] appeared.

Thanks,
Christian.

[0] http://lkml.org/lkml/2008/3/7/308
-- 
BOFH excuse #2:

solar flares
