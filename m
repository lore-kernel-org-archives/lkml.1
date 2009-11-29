Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbZK2VoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbZK2VoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 16:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbZK2VoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 16:44:21 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:48313 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbZK2VoU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 16:44:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lt4Ac1WbFDynx+Zi6QMBFOKGwiBU7cTpoTtBZgtkeV/akexYTHJ+sSxd47BUmJb91w
         Uks6gOxnfTr7fKL8YuKiHsKORyZv4ZzMdcGa/4VSPUn7gVhAjKavbQ2VnBBJ+iUgkMj4
         Eu9py2u94ouExAJRYT3lW5BCOBv3mWbOgo+mw=
MIME-Version: 1.0
In-Reply-To: <20091128081440.36265403.buchner.johannes@gmx.at>
References: <20091127155148.dcc5cdee.buchner.johannes@gmx.at>
	 <20091127030050.GC5406@nowhere>
	 <20091128081440.36265403.buchner.johannes@gmx.at>
Date: Sun, 29 Nov 2009 22:44:24 +0100
Message-ID: <a08621850911291344gd99b9bav21d317d15c862c80@mail.gmail.com>
Subject: Re: Fw: reiser4 git repo
From: Dushan Tcholich <dusanc@gmail.com>
To: Johannes Buchner <buchner.johannes@gmx.at>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       reiserfs-devel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 27, 2009 at 8:14 PM, Johannes Buchner
<buchner.johannes@gmx.at> wrote:
> Hi,
>

Hello

> I had some issues with the reiser4 patch series from -mm.
> First of all, I'm not sure what release they are based on. I used
> a8a8a669e from Linus' git repository. I applied all reiser4 patches
> (except reiser4-disable of course) from
> http://userweb.kernel.org/~akpm/mmotm/, which worked fine.
>
> I think these patches are based on the reiser4-2.6.30 patch.
> I also compared them to the reiser4-2.6.31 patch, which adds some
> missing pieces ([1] reiser4-from-2.6.31-patch.patch).
>
> Additionally, some recent commits demand some changes, especially
> since current_is_pdflush and generic_sync_sb_inodes are not available
> any more (d8a8559cd7a9cc).
> [2] reiser4-pdflush-comments.patch only fixes some comments which still
> mention pdflush.
> In [3] reiser4-generic_sync_sb_inodes.patch I tried to
> replace generic_sync_sb_inodes. I am not 100% sure that this is
> correct, but that is what I understood from the commit diff+message of
> d8a8559cd7a9cc.
>
> The original patch
> 'reiser4-vfs-add-super_operationssync_inodes' introduced the call from
> sync_inodes_sb to the super operation sync_inodes(sb, NULL). This NULL
> pointer is dereferenced in reiser4_sync_inodes, which is fixed by
> [4] reiser4-sync_inodes-null-dereference.patch.
>
> All 4 additional patches are attached. I can only say that it works on
> my machine, before I had compilation issues and freezes on 'sync'.
>
> Cheers,
> Johannes
>
> PS: The git repo mentioned in
> http://userweb.kernel.org/~akpm/mmotm/mmotm-readme.txt is not available.
>

Yeah, you can find it now at git.zen-kernel.org. They had to switch the adress.

Have fun

Dushan


> On Fri, 27 Nov 2009 04:00:51 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> On Fri, Nov 27, 2009 at 03:51:48PM +1300, Johannes Buchner wrote:
>> > [ I sent this 2 days ago to linux-fsdevel@vger.kernel.org, maybe
>> > I'll get more responses in here. ]
>> >
>> > Hi!
>> >
>> > I would like to keep a git repo up to date with current kernel
>> > development, with reiser4 patched in. I am having trouble finding a
>> > repo that provides reiser4. Is there one?
>> >
>> > Some people may have noticed the last patch doesn't apply cleanly
>> > anymore. I made a few lines of modifications in my local repo. Maybe
>> > that repo would be interesting for others too*.
>> >
>> > I plan to catch up with changes from kernel development on a
>> > daily/weekly basis; my /home partition is reiser4, so I am fairly
>> > serious about it.
>> >
>> > At the moment, I fetch from torvalds/linux-2.6.git and
>> > stable/linux-2.6.31.y.git. Am I missing any other repositories that
>> > I should try to keep up with? (A fs subsystem maintainer repo?)
>> > next/linux-next.git is probably moving too fast for me.
>>
>>
>> You can try the -mm tree, the reiser 4 patches can be found inside:
>>
>> http://userweb.kernel.org/~akpm/mmotm/
>
> --
> Emails können geändert, gefälscht und eingesehen werden. Signiere oder
> verschüssele deine Mails mit GPG.
> http://web.student.tuwien.ac.at/~e0625457/pgp.html
>
>
>
