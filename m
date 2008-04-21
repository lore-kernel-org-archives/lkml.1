Return-Path: <linux-kernel-owner+w=401wt.eu-S1759175AbYDUXf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbYDUXf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbYDUXfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:35:21 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:27052 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbYDUXfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:35:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wFzY5QI/T+RTNDq2mbwL4oFK+lirjfHBDDI/BuIaudeFvOthdLfMor0L2kL8LkdxT3gP0tXD9KeS8RIBUTv1kKriy+6UC9CNXm3qprvLHi7KFGOymWYV1mYg3uNSxoJyC67DBlnzuwe8g7jgajbVLYP/bOVSyNoJHFcq/VBcVQM=
Message-ID: <9a8748490804211635j134145c3gd8248524e8cc3272@mail.gmail.com>
Date: Tue, 22 Apr 2008 01:35:16 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Please pull the (new) Trivial tree
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <bunk@stusta.de>
In-Reply-To: <alpine.LFD.1.10.0804211626230.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490804211615y25329beapf019d3c2907defe6@mail.gmail.com>
	 <9a8748490804211621s7e19394bn6911d8d093fcb8dc@mail.gmail.com>
	 <alpine.LFD.1.10.0804211626230.2779@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/04/2008, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
>  On Tue, 22 Apr 2008, Jesper Juhl wrote:
>  > >
>  > >  Please pull git://git.kernel.org/pub/scm/linux/kernel/git/juhl/trivial.git
>  > >  for-linus
>
>
> Please format this differently. I want to use cut-and-paste rather than
>  re-typing random letter combinations that people use, so please write this
>  as
>
>    Please pull branch 'for-linus' of my trivial tree from
>
>
>         git://git.kernel.org/pub/scm/linux/kernel/git/juhl/trivial.git for-linus
>
>
>    to get these changes:
>         ...
>

Understood. I'll use that format in the future. Thank you.

>  where the important part is that I want the git repo address _and_ the
>  branch on one line, all by themselves. That way I don't have to pick
>  things up, I can just cut-and-paste the whole line (triple-click) without
>  worrying about boundaries or finding branch names somewhere else.
>
Makes sense. Will do.

>  > I guess one thing I should remember to do is include the git-shortlog
>  > of the changes I'm asking you to pull ;-)
>
>
> Also, git diffstat output, ie the output from a command something like:
>
>         git diff --stat --summary -M origin...
>
>  In fact, I think "git request-pull" will basically generate all of this.
>
Ok, I'll be sure to include that going forward.
Here it is for this pull request ('git diff --stat --summary -M
3925e6fc1f774048404fdd910b0345b06c699eb4' - hope that's right) :

 Documentation/DocBook/kernel-locking.tmpl          |    4 ++--
 Documentation/DocBook/writing_usb_driver.tmpl      |   14 +++++++-------
 Documentation/SubmittingPatches                    |    4 ++--
 Documentation/block/biodoc.txt                     |    2 +-
 Documentation/cli-sti-removal.txt                  |    2 +-
 Documentation/dontdiff                             |    1 -
 Documentation/early-userspace/README               |    4 ++--
 .../firmware_class/firmware_sample_driver.c        |   14 ++++++--------
 MAINTAINERS                                        |    7 ++++++-
 Makefile                                           |    2 +-
 arch/arm/mach-pxa/mfp.c                            |    6 +++---
 drivers/acpi/ac.c                                  |    2 +-
 drivers/char/sonypi.c                              |    2 +-
 drivers/dma/dmaengine.c                            |    6 +++---
 drivers/md/md.c                                    |    2 +-
 drivers/media/dvb/frontends/or51132.c              |    4 ++--
 drivers/media/video/sn9c102/sn9c102_sensor.h       |    2 +-
 drivers/media/video/v4l1-compat.c                  |    2 +-
 drivers/misc/intel_menlow.c                        |    2 +-
 fs/ext2/ialloc.c                                   |    2 +-
 fs/ext2/inode.c                                    |    4 ++--
 fs/ext3/ialloc.c                                   |    2 +-
 fs/ext3/inode.c                                    |    6 +++---
 fs/ext4/ialloc.c                                   |    2 +-
 fs/ext4/inode.c                                    |    6 +++---
 fs/select.c                                        |    2 +-
 include/asm-arm/hardware/iop3xx-adma.h             |    4 ++--
 include/keys/rxrpc-type.h                          |    2 +-
 include/linux/dmaengine.h                          |    2 +-
 include/linux/jiffies.h                            |    2 +-
 include/linux/mmzone.h                             |    1 -
 kernel/signal.c                                    |    4 ++--
 kernel/stop_machine.c                              |    3 +--
 mm/pdflush.c                                       |    4 ++--
 net/core/sock.c                                    |    1 -
 sound/pci/sis7019.c                                |    6 +++---
 sound/ppc/snd_ps3.c                                |    2 +-
 37 files changed, 68 insertions(+), 69 deletions(-)


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
