Return-Path: <linux-kernel-owner+w=401wt.eu-S936780AbXHJOmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936780AbXHJOmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 10:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760908AbXHJOmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 10:42:22 -0400
Received: from mail.jambit.com ([62.245.207.83]:34725 "EHLO mail.jambit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759833AbXHJOmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 10:42:21 -0400
X-Greylist: delayed 1182 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Aug 2007 10:42:21 EDT
Message-ID: <46BC744A.3030806@gmx.net>
Date: Fri, 10 Aug 2007 16:20:58 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-2.64 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I recently released man-pages-2.64.

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/manpages
    or ftp://ftp.kernel.org/pub/linux/docs/manpages

Changes in this release that may be of interest to readers of this list are
noted below.

Cheers,

Michael
(man-pages maintenance is supported by Google, as a Google engineer 20%
project.)



==================== Changes in man-pages-2.64 ====================

Global changes
--------------

Many pages
    mtk
        Added/updated feature test macro requirements for
        glibc; see feature_test_macros.7 for details.

Changes to individual pages
---------------------------

setpgid.2
    mtk
        Fairly substantial changes and corrections, including adding
        coverage of all of the interfaces that get/set PGIDs.

syscalls.2
    mtk / aeb
        Varous rewordings; clear up some imprecisions.

strerror.3
    mtk
        Note that the XPG version is provided since glibc 2.3.4.
        The page formerly said that the GNU-specific version
        is provided by default.  That certainly isn't true
        nowadays, since _POSIX_C_SOURCE is set to 200112L by
        default, so that the XSI-compliant version is supplied
        by default.

man-pages.7
    mtk
        Added note pointing to feature_test_macros.7 for a description
        of how feature test macro requirements should be specified in
        manual pages.  Various other minor fixes and changes.

feature_test_macros.7
    mtk
        Added note about how feature test macros are specified
        in manual pages.
        Many other corrections, improvements, additions, and
        details about differences across glibc versions.

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.

