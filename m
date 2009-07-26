Return-Path: <linux-kernel-owner+w=401wt.eu-S1751989AbZGZFWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbZGZFWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 01:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbZGZFWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 01:22:18 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:59893 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbZGZFWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 01:22:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Cynm6BoHSFthC6yz5e8hrdj8ESs9gY+CDvXnKRsVQXJwR6Vk/cUd/10SbAYyQN/okW
         th7TCIP78JgREN8IZp0birxbIPCmUcBgsHSWZqgUp3nqwLIvMwFxSWMGGaVpCa1crlX8
         M4SmqjRwwefnimo9y3gfPymZQKwaoKi8JoOME=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
Date: Sun, 26 Jul 2009 07:22:16 +0200
Message-ID: <cfd18e0f0907252222r15140e99t293bf1565579fdc2@mail.gmail.com>
Subject: man-pages-3.22 is released
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.22.tar.gz - man pages for Linux

This release is now available for download at:

http://www.kernel.org/pub/linux/docs/man-pages
or ftp://ftp.kernel.org/pub/linux/docs/man-pages

man-pages nowadays also has a public git repository at

git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2009/07/man-pages-322-is-released.html )
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/

This release consists entirely of fixes to existing pages.

Cheers,

Michael

Changes to individual pages
---------------------------

getdents.2
    Michael Kerrisk
        The d_type field is fully supported on Btrfs

mount.2
    Michael Kerrisk
        Document MS_STRICTATIME, update description of MS_RELATIME
            Starting with Linux 2.6.30, the MS_RELATIME behavior became
            the default, and MS_STRICTATIME is required to obtain the
            traditional semantics.

wait.2
    Gokdeniz Karadag
        Document CLD_DUMPED and CLD_TRAPPED si_code values


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Watch my Linux system programming book progress to publication!
http://blog.man7.org/
