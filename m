Return-Path: <linux-kernel-owner+w=401wt.eu-S1755545AbZICOPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545AbZICOPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 10:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753130AbZICOPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 10:15:00 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:24484 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZICOOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 10:14:45 -0400
Message-ID: <4A9FCF53.10105@hp.com>
Date: Thu, 03 Sep 2009 10:14:43 -0400
From: jim owens <jowens@hp.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Ric Wheeler <rwheeler@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       david@lang.hm, Theodore Tso <tytso@mit.edu>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [testcase] test your fs/storage stack (was Re: [patch] ext2/3:
 document conditions when reliable operation is possible)
References: <20090826001645.GN4300@elf.ucw.cz> <200909021800.51096.rob@landley.net> <4A9F0F7A.1010805@hp.com> <200909022141.48827.rob@landley.net>
In-Reply-To: <200909022141.48827.rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley wrote:
> I think he understands he was clueless too, that's why he investigated the 
> failure and wrote it up for posterity.
> 
>> And Ric said do not stigmatize whole classes of A) devices, B) raid,
>> and C) filesystems with "Pavel says...".
> 
> I don't care what "Pavel says", so you can leave the ad hominem at the door, 
> thanks.

See, this is exactly the problem we have with all the proposed
documentation.  The reader (you) did not get what the writer (me)
was trying to say.  That does not say either of us was wrong in
what we thought was meant, simply that we did not communicate.

What I meant was we did not want to accept Pavel's incorrect
documentation and post it in kernel docs.

> The kernel presents abstractions, such as block device nodes.  Sometimes 
> implementation details bubble through those abstractions.  Presumably, we 
> agree on that so far.

We don't have any problem with documenting abstractions.  But they
must be written as abstracts and accurate, not as IMO blogs.

It is not "he means well, so we will just accept it".  The rule
for kernel docs should be the same as for code.  If it is not
correct in all cases or causes problems, we don't accept it.

jim
