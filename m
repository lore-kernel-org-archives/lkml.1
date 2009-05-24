Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbZEXTly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbZEXTly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 15:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbZEXTlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 15:41:37 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:50850 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbZEXTlf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 15:41:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cXqwU9bR+R7MzhHkHxd8xfhOM7yOMAhC8FdT4NBeWBvApqPu6JC0hEiaya64vp0eu0
         tPLYUTHzFmHyxioIyjuZLEWkztqjetf70qCgkstIxbUiHKDTfRulERUN0Zl6YTSex8kO
         KMpXjwvPiV7W4TyrqHiDxjA9riuxlX+Bsm8nw=
MIME-Version: 1.0
In-Reply-To: <20090522105033.1426d409.sfr@canb.auug.org.au>
References: <c62985530905201640j4a550b5bi7673e5a9f21029ce@mail.gmail.com>
	 <20090522105033.1426d409.sfr@canb.auug.org.au>
Date: Sun, 24 May 2009 21:41:35 +0200
Message-ID: <c62985530905241241x2c72e92dn8265fe849b1f0b07@mail.gmail.com>
Subject: Re: kill-the-bkl/reiserfs: request for linux-next inclusion
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Reiserfs <reiserfs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 22 mai 2009 02:50, Stephen Rothwell <sfr@canb.auug.org.au> a écrit :
> Hi Frédéric,
>
> On Thu, 21 May 2009 01:40:57 +0200 Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>>
>> I guess Al is traveling or something.
>>
>> Until it finds its way to the VFS tree, it would be nice if this
>> reiserfs bkl removal tree could be included in linux-next
>> for testing.
>> Could you please include it ?
>>
>> You can pull from:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
>> reiserfs/kill-bkl-rc6
>
> I have included this tree from today.
>
> What I tell everyone: all patches/commits in the tree/series must
> have been:
>
>        posted to a relevant mailing list
>        reviewed
>        unit tested
>        destined for the next merge window (or the current release)



Thanks,

I remember there was a checklist like that for linux-next but couldn't
retrieve it.
They meet all these requirements except the reviewed part.
Some of them have been reviewed by several people but not the last batches,
(or at least the last batches haven't received any comments).



> *before* they are included.  The linux-next tree is for integration
> testing and to lower the impact of conflicts between subsystems in the
> next merge window.
>
> Basically, this should be just what you would send to Linus (or ask him
> to fetch).  It is allowed to be rebased if you deem it necessary.


Ok thanks.


> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>
