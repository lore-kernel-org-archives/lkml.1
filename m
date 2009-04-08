Return-Path: <linux-kernel-owner+w=401wt.eu-S1762615AbZDHGl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762615AbZDHGl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 02:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbZDHGlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 02:41:44 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:29804 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762179AbZDHGln convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 02:41:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G4ILm3GtcYCGnIycFjPbcIr4sYFIbB9Om9fGh0NSHl5OFRKIFvOivfGSLH3TR1BxPa
         SevUkT3eqxKSPGlTnqiPxvgESqGF7by+zORE/5K/FEgXLRcKv3SFlKs4tgsmADqMbDQm
         E3p7nI4UHOMauQYnjx2xRPepHdG1QaD8R/Dsw=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904071700170.4583@localhost.localdomain>
References: <alpine.LFD.2.00.0904071700170.4583@localhost.localdomain>
Date: Wed, 8 Apr 2009 14:41:42 +0800
Message-ID: <df9815e70904072341ic2a8621s12994ab4f4ba7fb3@mail.gmail.com>
Subject: Re: Linux 2.6.30-rc1
From: Jike Song <albcamus@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 8:20 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So the two week merge window has closed, and just as well - because we had
> a lot of changes. As usual. Certainly I had no urges to keep the window
> open to get those last remaining few megabytes of patches..
>
> The changes follow roughly the same pattern they have before: one third
> crap (that is, "staging" - the new random drivers that aren't really ready
> to be merged properly but get into the tree in the hope that they'll get
> better some day), one third real drivers, and one third "rest".
>
> And just to not break a new tradition, there's a few new filesystems in
> this release too:
>
>  - "nilfs2" has been brewing for a long while, and is another
>   log-structured filesystem that does snapshotting. Just google for
>   'nilfs2' for more details.
>
>  - "exofs" implements a filesystem on top of an external object store
>   (ie not a traditional storage of a linear array of anonymous blocks,
>   but a "smart" disk that does objects). See
>
>                Documentation/filesystems/exofs.txt
>
>   for some details.
>
>  - fscache/cachefiles is not really a filesystem, but infrastructure to do
>   caching of remote filesystems in the local filesystem, and NFS and AFS
>   have been updated to be able to use it.
>
> I'm personally hoping that we'll run out of filesystems rather than
> continue this new tradition indefinitely, but we'll see.
>
> But we've got older filesystems updated too: btrfs hopefully uses less
> stack space and is usable with a 4k stack, reiserfs got some updates, and
> a lot of other filesystems got minor refreshes. The ext3 changes are small
> enough to not show up in any dirstat, but hey, I think the fsync latency
> changes are interesting and probably more relevant to lots of people than
> most of the other changes.
>
> Other? Arch updates - amainly rm, powerpc, sh and x86. Firmware updates.
> And lots and lots of driver updates, including some more core
> suspend/resume changes (hopefully the last really fundamental ones).
>
> Go out and try it,
>
>                Linus

There is no way to build if one has CONFIG_SERIAL_MAX3100 selected to
be 'y' or 'm' - there is not max3100.c at all...


-- 
Thanks,
Jike
