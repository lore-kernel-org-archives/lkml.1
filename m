Return-Path: <linux-kernel-owner+w=401wt.eu-S1751745AbXLDBMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbXLDBMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 20:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbXLDBMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 20:12:22 -0500
Received: from mail46.e.nsc.no ([193.213.115.46]:46910 "EHLO mail46.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbXLDBMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 20:12:22 -0500
X-Greylist: delayed 2467 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Dec 2007 20:12:21 EST
From: Lars Hjemli <hjemli@gmail.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org, Lars Hjemli <hjemli@gmail.com>
Subject: cgit for kernel.org
Date: Tue,  4 Dec 2007 01:30:22 +0100
Message-Id: <1196728222-17300-1-git-send-email-hjemli@gmail.com>
X-Mailer: git-send-email 1.5.3.6.961.gecf4
In-Reply-To: <9wlfz-4hf-9@gated-at.bofh.it>
References: <9wlfz-4hf-9@gated-at.bofh.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> Repository overview.
> 	CGIT: http://cgit.freedesktop.org/
> 	GITWEB: http://git.kernel.org/

Why not compare more equal pages? freedesktop.org also runs gitweb:
  http://gitweb.freedesktop.org

>
> 	Remarks:
> 	cgit is lacking the links "shortlog", "log", "tree" and "git"
> 	which gitweb prints for each repository line.

Adding "enable-index-links=1" to /etc/cgitrc will print links to "summary",
"log" and "tree" for each repository line, but you still have to open the
summary page to get the git (clone) link. It wouldn't be very hard to add
another link (see http://hjemli.net/git/cgit/tree/ui-repolist.c#n96), but I'm
not sure what actual value such a link would provide.

>
> Inside a repository.
> 	CGIT: http://cgit.freedesktop.org/hal/

The similar page in gitweb:
  http://gitweb.freedesktop.org/?p=hal.git;a=summary

> 	GITWEB:
>http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=summary

The similar page in cgit:
  http://hjemli.net/git/linux/

> 	Remarks:
> 	In cgit, the left gray panel went by quite unnoticed

IMHO the sidebar makes cgit way easier to navigate (especially the dropdown box
to switch between branches is pretty handy).

>
> Clicking on a commit.
> 	CGIT:
>http://cgit.freedesktop.org/hal/commit/?id=b8f72cec53415ebc2d32805b049dcc94cef4a854

Similar page in gitweb:
http://gitweb.freedesktop.org/?p=hal.git;a=commit;h=b8f72cec53415ebc2d32805b049dcc94cef4a854


> 	GITWEB:
>http://git.kernel.org/?p=linux/kernel/git/jgarzik/misc-2.6.git;a=commit;h=8c27eba54970c6ebbb408186e5baa2274435e869

Similar page in cgit:
http://hjemli.net/git/linux/commit/?id=8c27eba54970c6ebbb408186e5baa2274435e869


>
> 	Remarks:
> 	cgit comes with a diffstat. Not that I look at diffstats all that
> 	often anyway. Still need to click on "(diff)" go get a diff.

There's always the link in the sidebar ;-)

But seriously, showing the diff on the same page as the commit message would
sometimes be nice and sometimes it would be a bit too much:
http://hjemli.net/git/linux/commit/?id=b5faa4b89e4d83203b1f44f143a351b518f7cda2
http://git.kernel.org/?p=linux/kernel/git/jgarzik/misc-2.6.git;a=commit;h=b5faa4b89e4d83203b1f44f143a351b518f7cda2


>
> 	Filenames are displayed with monospace font in gitweb :)
> 	Clicking on the commit actually shows its diff in gitweb.

I belive cgit and gitweb displays roughly the same information on their commit
pages; I don't see a diff in gitweb either unless I click one of the diff-
links.


>
> Final remark:
> 	gitweb has the warmer colors.

Yes, gitweb definitly looks more polished. It's a bit slow, though...

Another remark - IMHO there are some practical benefits to be had from the
virtual url support in cgit, e.g. linking to blobs:

http://gitweb.freedesktop.org/?p=xorg/xserver.git;a=blob;h=ace11817054bfb5bcc8d55a31bd51b9dea49bbed;hb=fe25f897c62bb324660217e15dbd3091c808dbba;f=GL/mesa/X/Makefile.am

http://cgit.freedesktop.org/xorg/xserver/tree/GL/mesa/X/Makefile.am

--
larsh
