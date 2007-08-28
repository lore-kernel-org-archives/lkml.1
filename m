Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbXH1QP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbXH1QP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 12:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbXH1QPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 12:15:48 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:32976 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbXH1QPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 12:15:47 -0400
Message-ID: <46D44A09.5060901@oracle.com>
Date: Tue, 28 Aug 2007 09:15:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Michael Evans <mjevans1983@gmail.com>
CC: Bill Davidsen <davidsen@tmr.com>,
       "Michael J. Evans" <mjevans1983@comcast.net>,
       Neil Brown <neilb@suse.de>, Ingo Molnar <mingo@redhat.com>,
       linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v3 1/1] md: Software Raid autodetect dev list not array
References: <200708222058.45480.mjevans1983@comcast.net>	 <200708271516.21889.mjevans1983@comcast.net>	 <20070827153020.43788e21.randy.dunlap@oracle.com>	 <200708272138.19785.mjevans1983@comcast.net>	 <46D3A8AD.6000701@oracle.com>	 <4877c76c0708280608m529296edgd83f9c08e3918815@mail.gmail.com>	 <46D421F6.50205@tmr.com> <4877c76c0708280632t3eb40d01od1267c8c4a7d8de@mail.gmail.com>
In-Reply-To: <4877c76c0708280632t3eb40d01od1267c8c4a7d8de@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Evans wrote:
> On 8/28/07, Bill Davidsen <davidsen@tmr.com> wrote:
>> Michael Evans wrote:
>>> Oh, I see.  I forgot about the changelogs.  I'd send out version 5
>>> now, but I'm not sure what kernel version to make the patch against.
>>> 2.6.23-rc4 is on kernel.org and I don't see any git snapshots.
>>> Additionally I never could tell what git tree was the 'mainline' as it
>>> isn't labeled with such a keyword (at least in the list of git trees I
>>> saw).
>> 
>> I suspect you wait for 2.5.23 release, or send it to AKPM for inclusion
>> in an "-mm" kernel. That's probably desirable, anyway.
>>
>> --
> 
> There's another list I should CC to?  Or does the section maintainer
> do that when they're happy with the patch?

Not another list; just cc: akpm@linux-foundation.org so that he can merge
it into the -mm kernel patches for testing.  Most patches cook in the -mm
kernel(s) before they are merged into mainline.

Then generally the subsystem maintainer(s) are responsible for sending
patches on to Linus for merging into mainline, if/when they are happy
with the patch and they think that it has been tested enough.

Mainline progresses (roughly, e.g.) like so:

2.6.22
then patches are applied and we get (possibly) daily snapshots from git, like
2.6.22-git1, 2.6.22-git2, ...

After the primary 2-week merge window for new code (i.e., not just bug fixes),
we get 2.6.23-rc1.
Then as more patches are merged, we get 2.6.23-rc1-gitN...

Then 2.6.23-rc2 ... 2.6.23-rc2-gitN...

2.6.23-rc3 ... 2.6.23-rc3-gitN...

blah blah blah

You can use git to download and track the mainline kernel changes,
or you can download tarballs + patches (patches for each -rc as well as
for each -gitN snapshot) and apply the patches yourself or use a
script to do it. (like 'ketchup': http://www.selenic.com/ketchup/wiki/;
or like http://www.xenotime.net/linux/scripts/grab_kernel)

In general, patches should be made against latest/recent kernels, either
current git (cloned or updated via pull), or against recent patches
+ git snapshot if there is a git snapshot that is applicable.
Immediately after 2.6.23-rcN, there is no applicable git snapshot to
be applied (well, a few hours later there may be).

Sometimes it is appropriate to make patches against the -mm kernel
patchset, but only if the patch is for code that is only in that
kernel patchset (or if Andrew asks for a patch to be updated against
-mm).  [This is a mostly rough generalization.]  Andrew normally
takes patches against mainline and coerces them into -mm if coercion
is needed.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
