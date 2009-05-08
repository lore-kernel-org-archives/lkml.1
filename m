Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbZEHJWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbZEHJWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 05:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZEHJW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 05:22:27 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:25141 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbZEHJW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 05:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iL1NmUrovkRmz3jv4Vq2lewEa6QlHuwy0oDvlj+l9QIEqeBJh2+K1izzcuHQeuFHba
         ImzzWbqYNUYqgDXhSVi5xxUu7R4t9wHpYL6Cdm2eIRJefnuaZsNnRDMStE9muj27fzqO
         590si21zE4UR3cwJDlta+EvTymWhsntgoKGmY=
MIME-Version: 1.0
In-Reply-To: <1240855555.5529.11.camel@think.oraclecorp.com>
References: <1240855555.5529.11.camel@think.oraclecorp.com>
Date: Fri, 8 May 2009 17:22:26 +0800
Message-ID: <b6a2187b0905080222r53c7ed80s6d2ff91d386cd963@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs updates for 2.6.30-rc
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 2:05 AM, Chris Mason <chris.mason@oracle.com> wrote:
> Hello everyone,
>
> The master branch of:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git
>
> Has a few btrfs bug fixes, performance fixes and a few cleanups.  The
> highlights are some code from Josef Bacik to for metadata block group
> preallocation, which will help cut down on the chances of metadata
> enospc.


Chris,

Any chance to create a btrfs partition less than 256MB? I'm looking at
using btrfs when it's stable enough for all partitions rather than
some btrfs and smaller ones non-btrfs. Currently, reiserfs/reiser4
supports smaller than 100MB which is good for testing.

in btrfs-progs-0.18/mkfs.c ...
                                if (block_count < 256*1024*1024) {
                                        fprintf(stderr, "File system size "
                                                "%llu bytes is too small, "
                                                "256M is required at least\n",
                                                block_count);
                                        exit(1);
                                }

Also, would it be possible when creating a 300MB partition for "df" to
display "50MB free" instead of "300MB free"?

Thanks,
Jeff.
