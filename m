Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbZDUFBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbZDUFBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 01:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753531AbZDUFBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 01:01:01 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:41756 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbZDUFA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 01:00:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=iOpudVMk16P46oNAeJhgjB6qDbecI+e0Bg0OMOSenSlB4LGMuFMDXa+UTDUxz2G4d/
         pCAt70TDMmhgY2fRpm8I8o/SR0CBSyrEILDly4CYEvQoclKcXQgvJI/eZU/Oqi4xEUqR
         InlDXgycIORH4sgjg6oZ/mwlaVdg8OZ0fbgWk=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
Date: Tue, 21 Apr 2009 17:00:56 +1200
Message-ID: <cfd18e0f0904202200p5544c183j542e1e963b61f146@mail.gmail.com>
Subject: man-pages-3.21 is released
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.21.tar.gz - man pages for Linux

This release is now available for download at:

http://www.kernel.org/pub/linux/docs/man-pages
or ftp://ftp.kernel.org/pub/linux/docs/man-pages

man-pages nowadays also has a public git repository at

git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2009/04/man-pages-321-is-released.html )
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/
An abridged list of changes that may be of interest to readers of this
list is given below.

Cheers,

Michael

==================== Changes in man-pages-3.21 ====================

New and rewritten pages
-----------------------

pthread_setconcurrency.3
    Michael Kerrisk
        New page documenting pthread_setconcurrency(3) and
        pthread_getconcurrency(3)

pthread_yield.3
    Michael Kerrisk
        New page documenting pthread_yield(3)

Changes to individual pages
---------------------------

feature_test_macros.7
    Michael Kerrisk
        Update for glibc 2.10 changes to <features.h>
            From glibc 2.10, <features.h> understands the values 200809
            for _POSIX_C_SOURCE and 700 for _XOPEN_SOURCE, and makes
            corresponding changes to defaults for other feature test macros.
    Michael Kerrisk
        Add an example program
            This example program makes it possible to explore what
            feature test macros are set depending on the glibc version
            and the macros that are explicitly set.
