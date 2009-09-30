Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbZI3XZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbZI3XZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 19:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbZI3XZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 19:25:34 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:49636 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbZI3XZe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 19:25:34 -0400
Date: Thu, 01 Oct 2009 01:25:36 +0200
Message-Id: <935466370@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [GIT PULL] block updates for 2.6.32-rc
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19rOnrqQxDjyJH8Vibz0QaNE3rUNdyYWUzn5Gf3mAiupnEso
 tby/WwlGy2WXcvhm5rkPdtP6zQpxQYgjutJCw8MO5sQXr3YGO4=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Hi Linus,
>> 
>> This looks huge, but it's mostly a cciss driver update and the addition
>> of drbd. I would have submitted this before -rc1, but Plumbers got in
>> the way.
>
>And DRBD is defintively not ready.  Even if people want to merge another
>duplicate RAID driver including another crappy user interface it has
>tracing stuff of a form that would let Ingo go beserk and also uses the
>stupid connector.

so, if DRBD is too ugly to be merged, i wonder why it`s not put in staging 
then before other kernel devs find yet another reason for not merging it 
at all. if they want it to be cleaned up, they can do it there or they can 
make the driver maintainer do it. or they can do it together. or they can 
let just sit it there until greg complains :)

all in all, it`s better than letting brilliant things like these live outside the
kernel tree. (which is more than 8 yrs now for DRBD)

What the Linux Staging tree is
The Linux Staging tree (or just "staging" from now on) is used to hold 
stand-alone drivers and filesystems that are not ready to be merged into 
the main portion of the Linux kernel tree at this point in time for various 
technical reasons. It is contained within the main Linux kernel tree so that 
users can get access to the drivers much easier than before, and to provide 
a common place for the development to happen, resolving the "hundreds 
of different download sites" problem that most out-of-tree drivers have had 
in the past.

( taken from http://www.kroah.com/log/linux/linux-staging-update.html )




______________________________________________________
GRATIS für alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de

