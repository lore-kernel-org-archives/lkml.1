Return-Path: <linux-kernel-owner+w=401wt.eu-S1754283AbZJEWSC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbZJEWSC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 18:18:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZJEWSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 18:18:01 -0400
Received: from relay01-haj2.antispameurope.com ([83.246.65.51]:49960 "EHLO
	relay01-haj2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754089AbZJEWSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 18:18:00 -0400
Date: Tue, 06 Oct 2009 00:15:48 +0200
From: Joerg.Schilling@fokus.fraunhofer.de (Joerg Schilling)
To: Valdis.Kletnieks@vt.edu
Cc: shawn.starr@rogers.com, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM][2.6.31.1] - Cannot burn DVDs - PIONEER DVD-RW DVR-111D
Message-ID: <4aca7014.bWkj1S1Z6N2kt4dr%Joerg.Schilling@fokus.fraunhofer.de>
References: <4ac9d477.7gleZfWVJq3++UDn%Joerg.Schilling@fokus.fraunhofer.de>
 <172428.1254779700@turing-police.cc.vt.edu>
In-Reply-To: <172428.1254779700@turing-police.cc.vt.edu>
User-Agent: nail 11.22 3/20/05
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Oct 2009 22:17:15.0099 (UTC) FILETIME=[97EC82B0:01CA4609]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:

> > It is very likely that this problem does not occur with the original
> > cdrecord from:
>
> > ftp://ftp.berlios.de/pub/cdrecord/alpha/
>
> Yes, but his distro probably feels it can't ship the original cdrecord
> so it ships wodim instead.  And if it's indeed a kernel bug, replacing
> a forked userspace program to work around a kernel bug is The Wrong Answer.
>
> It forked 3 whole years ago, Joerg.  Let it go already. And if you can't
> let it go, at least ask the user *helpful* questions, like Jeff Garzik did:

Just in case you don't know:

It is the fork that cannot be distributed legally because the fork has been 
made to be in conflict with the copyright law. And it is the fork that is still
full of bugs that never have been in the original software. The fork did see 
some speudo activity in the time between september 2006 and May 6th 2007 but it
is dead since then. 

You can help: Ask your Linux distributor why he distributes an illegal and 
buggy fork instead of the legal original software!

The fork is a problem caused by a hostile packetizer, see:

http://cdrecord.berlios.de/private/linux-dist.html

We, the OSS creators need to find a way to deal with hostile downstreams. Don't
look away when free software is atackedby hostile downstreams....

Back to the original topic: I cannot help you if you don't understand that
I was of course answering to the problem of the OP and the only kernel problem
I can see in the OP is that the kernel should of course not print such "error"
messages at all as errors from SCSI pass through commands are not handled by 
the kernel but by the application program that is the only instance that knows 
whether a specific SCSI error should be exposed to the user.

As I mentioned before, the OP reported a problem that I've seen before elsewhere 
and that problem was reported to disappear after upgrading to cdrecord.

Jörg

-- 
 EMail:joerg@schily.isdn.cs.tu-berlin.de (home) Jörg Schilling D-13353 Berlin
       js@cs.tu-berlin.de                (uni)  
       joerg.schilling@fokus.fraunhofer.de (work) Blog: http://schily.blogspot.com/
 URL:  http://cdrecord.berlios.de/private/ ftp://ftp.berlios.de/pub/schily
