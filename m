Return-Path: <linux-kernel-owner+w=401wt.eu-S1762086AbXIKFr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762086AbXIKFr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 01:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760086AbXIKFru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 01:47:50 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:20556 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbXIKFru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 01:47:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N5Uf0xOckr0Xvkg+CiPusrPHdypZcwsJ4OTqDMWlUEqTbo7frKCn1kdyue6OtijqYEwm6vEUip6Tqas+Opl4a4EH9qgaZOLMGUkg/reX0e1+Ydkc++2iZPqO0PLbiKKBMCRKdHBhLHHXDPtwL6gPXhBuN4PABrrIFeyWxlomF7Y=
Message-ID: <6bc632150709102247s3071c60jcddf8f88c8f2bc10@mail.gmail.com>
Date: Tue, 11 Sep 2007 11:17:48 +0530
From: "pradeep singh rautela" <rautelap@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [Q]Adding src files to 2.6.18 kernel and build failure query
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070910163847.GA30699@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6bc632150709100905y7c5c2camaa0044cf6fa09ea2@mail.gmail.com>
	 <20070910163847.GA30699@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/10/07, Sam Ravnborg <sam@ravnborg.org> wrote:
[...]
> > I added some .c files to a new dir under net/foo/ .
> > Added corresponding .h files to a new dir under include/foo/
> >
> > Create a Kconfig and Makefile in net/foo/ directory.
> > Added corresponding entries to Makefile and Kconfig in the net/ dir.
> >
> > I happily executed a make with a beaming face after selecting the foo
> > option after doing a
> > $make menuconfig.
> >
> > To my surprise i got this error :-
> >
> > make[1]: *** No rule to make target `arch/i386/kernel/vmlinux.lds',
> > needed by `__build'.  Stop
>
> Did the kernel build before you started adding your stuff?
> It looks like you broke something non-obvious when adding your stuff since the
> above failure should not happen just by adding a new directory under net/

Went home and tried again. It builds fine in git repo, but again
whenever i make an archive using git-archive --format=tar
--prefix=linux-2.6.18/ HEAD | bzip2 > linux-2.6.18.tar.bz2 , i get the
problem with this bzipped tree.

I removed .gitignore file from the my git repo and added manually
rules to .git/info/exclude instead. This did the trick and
git-archiv'ing did not result in a broken bzipped tree.

Perhaps i did something silly or may be something to do with git. ??

Thanks for the hint Sam.
--pradeep
--
pradeep singh rautela

"question = ( to ) ? be : ! be;"
                -- Wm. Shakespeare
