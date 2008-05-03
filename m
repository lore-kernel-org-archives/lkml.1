Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbYECEy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbYECEy1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 00:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYECEyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 00:54:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60458 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbYECEyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 00:54:18 -0400
Message-ID: <481BEFF7.507@garzik.org>
Date: Sat, 03 May 2008 00:54:15 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-next@vger.kernel.org, sfrench@us.ibm.com, swhiteho@redhat.com,
       stefanr@s5r6.in-berlin.de, ralf@linux-mips.org, drzeus-list@drzeus.cx,
       jack@ucw.cz, cbou@mail.ru, jens.axboe@oracle.com, ericvh@gmail.com,
       wim@iguana.be, chris@zankel.net, nico@cam.org, penberg@cs.helsinki.fi,
       clameter@sgi.com, ezk@cs.sunysb.edu, linux-kernel@vger.kernel.org
Subject: Re: git trees which are not yet in linux-next
References: <20080502151206.b40f77ea.akpm@linux-foundation.org>	<481B93AA.7040000@garzik.org> <20080502153301.8b27ac31.akpm@linux-foundation.org>
In-Reply-To: <20080502153301.8b27ac31.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 02 May 2008 18:20:26 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Andrew Morton wrote:
>>> (Jeff, git-libata-all is a pretty important one)
>>
>> libata-dev.git#NEXT is for linux-next, and libata-dev.git#ALL is for -mm
>>
>> Already taken care of.
>>
> 
> Oh.  Something seems to have gone wrong then.
> 
> Next/Trees has:
> 
> libata          git     git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git#NEXT
> 
> but:
> 
> y:/usr/src/25> diffstat patches/linux-next.patch | grep /ata/      
> y:/usr/src/25> 
> 
> There's nothing there?

Correct.  There is presently nothing waiting for linux-next.


> (plans for git-jg-misc?)

That's an ever-present bucket with ever-changing contents.  I put stuff 
in there when I have things for -mm testing, and hopefully, eventually 
upstream.

Sometimes jgarzik/misc-2.6.git#ALL might be empty (like libata-dev#NEXT 
is now), sometimes not.

The general point is to make sure both you and Stephen are pulling the 
right branches, which is sounds like you are.

	Jeff



