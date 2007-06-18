Return-Path: <linux-kernel-owner+w=401wt.eu-S933017AbXFRVfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017AbXFRVfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 17:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765659AbXFRVfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 17:35:07 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:42773 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765049AbXFRVfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 17:35:04 -0400
Date: Mon, 18 Jun 2007 23:25:24 +0200
From: Thomas Glanzmann <thomas@glanzmann.de>
To: carlo@alinoe.com, Linus Torvalds <torvalds@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Michael Gernoth <simigern@cip.informatik.uni-erlangen.de>,
       GIT <git@vger.kernel.org>
Subject: GIT Packages for Debian Etch
Message-ID: <20070618212524.GC16393@cip.informatik.uni-erlangen.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	carlo@alinoe.com, Linus Torvalds <torvalds@osdl.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Michael Gernoth <simigern@cip.informatik.uni-erlangen.de>,
	GIT <git@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
a friend of mine always builds the Debian Packages from unstable for
Debian Etch. I have on all my machines the following line in
/etc/apt/sources.list:

        deb http://rmdir.de/~michael/git/ ./

apt-get update; apt-get dist-upgrade

and you're up2speed.

If you don't trust that packages it is very easy to build them yourself:

        wget http://ftp.debian.org/debian/pool/main/g/git-core/git-core_1.5.2.1-1.dsc
        wget http://ftp.debian.org/debian/pool/main/g/git-core/git-core_1.5.2.1.orig.tar.gz
        wget http://ftp.debian.org/debian/pool/main/g/git-core/git-core_1.5.2.1-1.diff.gz
        dpkg-source -x git-core_1.5.2.1-1.dsc
        cd git-core-1.5.2.1/
        fakeroot debian/rules binary

It runs the whole test suite and only contiues producing debs if they're good
to go. It might be possible that you have to install some build dependencies by
yourself. If some new git version hits unstable you can get the references for
the three files above from:

        http://packages.debian.org/git-core
                => unstable
                => scroll to end of page
                => Source Packages
                => Source Package: git-core, Download: [dsc] ...

        Thomas
