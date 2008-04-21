Return-Path: <linux-kernel-owner+w=401wt.eu-S1756542AbYDUXVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542AbYDUXVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 19:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbYDUXVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 19:21:36 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:25417 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbYDUXVe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 19:21:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WboSPts8GmvV8h2jkF3AT9U3VUj1lv05W9x2ULudsG9gENCFTxD7UnUVlt0Y3GtnYBNPf7v0qVJnhV4mRu22muIZZwLh2k2SY+XUWmBlS6eYINmv360/2YookeXgWCbodBd6cEfREuZDlPAjAdcd2VAtazSENi0o/YwdCQEu0vc=
Message-ID: <9a8748490804211621s7e19394bn6911d8d093fcb8dc@mail.gmail.com>
Date: Tue, 22 Apr 2008 01:21:32 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Please pull the (new) Trivial tree
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <bunk@stusta.de>, "Jesper Juhl" <jesper.juhl@gmail.com>
In-Reply-To: <9a8748490804211615y25329beapf019d3c2907defe6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <9a8748490804211615y25329beapf019d3c2907defe6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/04/2008, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> Hi Linus,
>
>  Please pull git://git.kernel.org/pub/scm/linux/kernel/git/juhl/trivial.git
>  for-linus
>
>  This is the (new) trivial tree.
>
>  I took over Trivial maintainership from Adrian Bunk and this is my
>  very first pull request as maintainer, so please let me know if I've
>  done anything wrong.
>
>  I know you have better things to do than look through trivial patches
>  (that's my job now), but since this is the very first tree I've
>  created I would ask you to please take the time to look it over
>  carefully. I cloned your tip-of-tree and then applied all the patches
>  I had filtered out to a 'for-linus' branch. I plan to then merge those
>  patches back from you into my 'master' branch once you've pulled, then
>  ditch my 'for-linus' branch and create a new one with new patches once
>  the next merge window opens - if that's not the right way to go about
>  it, please let me know.
>
>  To the various other tree maintainers; if there are patches in this
>  tree that I should not have merged and then told Linus to pull, but
>  should instead have sent to you, please tell me so I can do a better
>  job next time. I want to develop a good working relationship with
>  other maintainers, but I'm new at this and don't know exactely what to
>  do, so I've tried my best and hope it's good enough - but if not, I
>  want to be told so I can learn and do better in the future.
>
>  I've tried to not add patches that were already merged elsewhere as
>  well as patches that didn't really qualify as trivial. I hope I
>  succeeded.
>
>  Any and all comments on the tree I created, the patches in it etc are
>  more than welcome.
>

I guess one thing I should remember to do is include the git-shortlog
of the changes I'm asking you to pull ;-)

Here it is :

Benoit Boissinot (1):
      ext*: spelling fix prefered -> preferred

Cyril Brulebois (1):
      Documentation: Remove last references to BitKeeper.

Jesper Juhl (1):
      Correct a few trivial tree details in Documentation/SubmittingPatches

Johannes Weiner (1):
      Remove unused MAX_NODES_SHIFT

Nick Andrew (1):
      RAID: remove trailing space from printk line

Pavel Machek (2):
      trivial: small cleanups
      firmware_sample_driver.c: fix coding style

Robert P. J. Day (5):
      MAINTAINERS: Clarify access to OCFS2 development mailing list.
      KEYS:  Fix the comment to match the file name in rxrpc-type.h.
      DOCUMENTATION:  Use newer DEFINE_SPINLOCK macro in docs.
      Generate a slightly more informative error msg for bad HZ
      DOC:  A couple corrections and clarifications in USB doc.

Rusty Russell (1):
      Remove documentation of non-existent sk_alloc arg

Sebastian Siewior (1):
      DMA engine: typo fixes

Tobias Klauser (8):
      acpi: Storage class should be before const qualifier
      ALSA: Storage class should be before const qualifier
      arm: Storage class should be before const qualifier
      DVB: Storage class should be before const qualifier
      intel_menlow: Storage class should be before const qualifier
      sonypi: Storage class should be before const qualifier
      V4L: Storage class should be before const qualifier
      V4L: Storage class should be before const qualifier (sn9c102)

Uwe Kleine-König (1):
      fix typo "is" -> "if" in Makefile

Ville Syrjala (1):
      MAINTAINERS: Add ati_remote2 driver


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
