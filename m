Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYJPOi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYJPOi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 10:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754002AbYJPOiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 10:38:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58560 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbYJPOip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 10:38:45 -0400
Message-ID: <48F751E9.8070705@redhat.com>
Date: Thu, 16 Oct 2008 09:38:33 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Pascal Terjan <pterjan@mandriva.com>
CC: Andrey Borzenkov <arvidjaar@mail.ru>, pterjan@mandriva.org,
       linux-ext4@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Possible ext3 corruption with 1K block size
References: <200810150724.42180.arvidjaar@mail.ru>	 <48F5E6D4.8080603@redhat.com> <200810151824.36119.arvidjaar@mail.ru>	 <48F601A5.1050405@redhat.com> <1224164860.11578.14.camel@plop>
In-Reply-To: <1224164860.11578.14.camel@plop>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pascal Terjan wrote:
> Le mercredi 15 octobre 2008 à 09:43 -0500, Eric Sandeen a écrit :
>> Andrey Borzenkov wrote:
>>> On Wednesday 15 October 2008, Eric Sandeen wrote:
>>
>>>> My kingdom for a testcase... does anyone have simple steps to reproduce
>>>> this?  Or do they all start with "install mandriva on a 1k block size
>>>> system?"  :)
>>>>
>>> May be RH will do? :)
>> I did try a 1k-block root fs Fedora install, and didn't see any problems...
>>
>>> As indicated by last comment, Pascal has some ways to trigger it; I
>>> forgot to Cc to him initially; doing it now.
>> Ok, good deal.
>>
> 
> On my test machine I reproduce it easily : rpm --rebuilddb and if the db
> is not detected to be corrupted yet it will be after installing a few
> packages (tested again with 2.6.27).
> 
> If I do the rebuilddb on a 2.6.17 and then reboot on a recent kernel,
> then I can install/uninstall thousands of packages without any
> corruption.

so it seems to be the database rebuilding, under a recent kernel, which
causes the problem?  installing under a recent kernel is ok, as long as
the db was created on an older kernel?

Ok that's a good clue...

-Eric
