Return-Path: <linux-kernel-owner+w=401wt.eu-S1031219AbXDZNCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031219AbXDZNCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031223AbXDZNCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:02:50 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:1753 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031219AbXDZNCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:02:49 -0400
Message-ID: <4630A2F5.4010009@shadowen.org>
Date: Thu, 26 Apr 2007 14:02:45 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, mb@bu3sch.de,
       linville@tuxdriver.com, arnd@arndb.de, maxextreme@gmail.com,
       gregkh@suse.de
Subject: Re: [PATCH 0/9] Kconfig: cleanup s390 v2.
References: <20070423141123.GA21174@skybase>	<20070423104534.51bac974.akpm@linux-foundation.org>	<20070425112133.4ae86399.randy.dunlap@oracle.com> <20070425143011.57247c1d.akpm@linux-foundation.org>
In-Reply-To: <20070425143011.57247c1d.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 25 Apr 2007 11:21:33 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
>> On Mon, 23 Apr 2007 10:45:34 -0700 Andrew Morton wrote:
>>
>>> On Mon, 23 Apr 2007 16:11:23 +0200
>>> Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
>>>
>>>> Greetings,
>>>> I've added the results of the review to the Kconfig cleanup patches
>>>> for s390. Patch #2 has been split, one half has all the HAS_IOMEM
>>>> depends lines the other the remaining !S390 depends lines.
>>>>
>>>> Andrew: I plan to add patches 1-5 to the for-andrew branch of the
>>>> git390 repository if that is fine with you. The only thing that will
>>>> be missing in the tree is the patch that disables wireless for s390.
>>>> The code does compile but without hardware it is mute to have the
>>>> config options. I'll wait until the git-wireless.patch is upstream.
>>>> Patches 7-9 depend on patches found in -mm.
>>>>
>>> umm, OK.  If it's Ok I think I'll duck it for now: -mm is full.
>>>
>>> Over-full, really: I've been working basically continuously since Friday
>>> getting the current dungpile to compile and boot, and it's still miles away
>>> from that.
>> and I continue to be concerned about the amount of patch reviews
>> compared to new patch material overall (not just s390).
>>
> 
> yes.  I'm increasingly reluctant to merge things which have had no visible
> review from any third party.  Nowadays I'll shove such patches into a
> pending folder and will wait a day or three to see if anyone has any
> feedback.  If they don't I have to either ignore the patches or review them
> myself.
> 
> I expect (and hope) that more formal processes will come about here.  Perhaps
> up to it-won't-be-merged-without-a-Reviewed-by:.

Is this not the meaning of the Acked-by: ?

> Heaven knows how many more serious problems are being snuck into the tree
> via this route.
> 
> What do we do?

Perhaps its time for Linus to say he won't accept any patches which are
not Acked and place the onus on getting those on the tree maintainers.
In theory at least tree maintainers are supposed to be responsible for
the stuff coming through their tree.  They could be made responsible to
ensuring only Ack'd stuff is committed.  Automated checks could be made
for that at least.

As for the white space errors.  I think that we should perhaps run a
spectrum of commits from each tree through the checked proposed later in
the thread.  Where any significant non-compliance is detected that
should be sent to the tree maintainer and their 'upstream' and
corrections expected.

Public shaming.  A savaging from Linus' or any other respected community
member is something to be avoided at all costs.

-apw
