Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbYECIsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbYECIsG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 04:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbYECIry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 04:47:54 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54169 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYECIrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 04:47:53 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <481C266F.9080003@s5r6.in-berlin.de>
Date: Sat, 03 May 2008 10:46:39 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       sfrench@us.ibm.com, swhiteho@redhat.com, ralf@linux-mips.org,
       drzeus-list@drzeus.cx, jack@ucw.cz, cbou@mail.ru, jens.axboe@oracle.com,
       ericvh@gmail.com, wim@iguana.be, chris@zankel.net, nico@cam.org,
       penberg@cs.helsinki.fi, clameter@sgi.com, ezk@cs.sunysb.edu,
       linux-kernel@vger.kernel.org
Subject: Re: git trees which are not yet in linux-next
References: <20080502151206.b40f77ea.akpm@linux-foundation.org>	<20080502154200.a6d8c43a.akpm@linux-foundation.org>	<481BBD84.10904@s5r6.in-berlin.de> <20080502183403.3d9f2d9f.akpm@linux-foundation.org> <481BEF7A.1060300@garzik.org>
In-Reply-To: <481BEF7A.1060300@garzik.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
>>> Andrew Morton wrote:
>>>> On Fri, 2 May 2008 15:12:06 -0700
>>>> Andrew Morton <akpm@linux-foundation.org> wrote:
>>>>
>>>>> The first
>>>>> problem is working out "how the heck did that patch get into 
>>>>> linux-next"? That would be much easier if the signoff trail was 
>>>>> complete for git-based
>>>>> patches, but it often is not.
>>>> doh.  I'm pulling linux-next's constituent trees independently, so if I
>>>> spot a turd in linux-next I can just grep the various git trees to 
>>>> find out
>>>> where it came from.
...
> Poke through the man pages, particularly git-log, and tell it to spit 
> out the committer info, then.  It's in there.
> 
> For example,
> 
>     git log --pretty=full
...

Of course some committers have more than one tree in -next.  So if 
Andrew wants to know the actual tree, the laziest method which I know of is
$ gitk <commit_id>

Among else, gitk shows which branches contain the commit.  (How to do 
this without X GUI?)
-- 
Stefan Richter
-=====-==--- -=-= ---==
http://arcgraph.de/sr/
