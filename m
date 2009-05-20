Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbZETXlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbZETXlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 19:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbZETXk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 19:40:58 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:62304 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbZETXk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 19:40:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MMhSQ/gqA3g9vsZEG8VFBNlVX8FEEhb1iF7ZYtcXqPIUAfsTSXZJd4e3oJ8WzKwiLa
         3kbrOqFbmqJ8JLfr7C7n2UOHPECdWb6wMKY8vqSVpLZAtFCfzioNBKxnnVlKbmN3hoUT
         P0Paor+GgJ0wYSHWmGBPRFpYqVYge3ZO9UA/w=
MIME-Version: 1.0
Date: Thu, 21 May 2009 01:40:57 +0200
Message-ID: <c62985530905201640j4a550b5bi7673e5a9f21029ce@mail.gmail.com>
Subject: kill-the-bkl/reiserfs: request for linux-next inclusion
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Reiserfs <reiserfs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/16 Frederic Weisbecker <fweisbec@gmail.com>:
> Hi Al, Stephen,
>
> This patchset is subsequent to a rebase of the bkl killing in reiserfs
> work rebased against -rc6. It contains only fixes.
> The old topic is left unchanged but the new one reiserfs/kill-bkl-rc6 can
> be pulled against -rc6 without problem.
>
> Also, Al, I don't know if you would still accept to apply this work in the VFS
> tree.
> The fact is that it becomes late in the process, we are already in -rc6
> and I would like it to be tested at least in linux-next.
>
> So, it's up to you. Whether you prefer to apply it and make it
> available to next, or I can ask Stephen to pull directly from my tree.
>
> Thanks,
> Frederic.
>
> The following changes since commit b693ba70c541a5a26eb4e8f2db5ade454afe1c74:
>  Frederic Weisbecker (1):
>        kill-the-bkl/reiserfs: unlock only when needed in search_by_key
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
>        reiserfs/kill-bkl-rc6


Stephen,

I guess Al is traveling or something.

Until it finds its way to the VFS tree, it would be nice if this
reiserfs bkl removal tree could be included in linux-next
for testing.
Could you please include it ?

You can pull from:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
reiserfs/kill-bkl-rc6

Thanks!


> Frederic Weisbecker (2):
>      kill-the-bkl/reiserfs: acquire the inode mutex safely
>      kill-the-bkl/reiserfs: move the concurrent tree accesses checks per superblock
>
>  fs/reiserfs/do_balan.c         |   17 +++++------------
>  fs/reiserfs/fix_node.c         |    5 +----
>  fs/reiserfs/journal.c          |   34 ----------------------------------
>  fs/reiserfs/prints.c           |    4 ----
>  fs/reiserfs/stree.c            |    5 +----
>  fs/reiserfs/xattr.c            |    4 ++--
>  include/linux/reiserfs_fs.h    |   35 +++++++++++++++++++++++++++++++++++
>  include/linux/reiserfs_fs_sb.h |   11 +++++++++++
>  8 files changed, 55 insertions(+), 60 deletions(-)
>
