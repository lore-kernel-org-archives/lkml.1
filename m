Return-Path: <linux-kernel-owner+w=401wt.eu-S1762689AbXLNIpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762689AbXLNIpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 03:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756537AbXLNIpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 03:45:43 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:44498 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbXLNIpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 03:45:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=VYSV5wZv0f7bC+KKr6X6wJ3qlBvi24Hmfo2yq8125crGfaA+hmm0yEjnpyznTDcMDVBL/VASTBZKHZnCUihdhbjrdwhXLiTSnKjt0jqV0e20rQp+6yrpByCixmOnaVxqbv1BdPFqJxKHF5zlrssZ6ZYu7rwMNx6KrdTPoLK7Qg0=
Message-ID: <476242FE.50805@gmail.com>
Date: Fri, 14 Dec 2007 09:46:54 +0100
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-2.71 and man-pages-2.72 are released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

Repeating some old news:

* man-pages now has a website:

      http://www.kernel.org/doc/man-pages

  The site includes HTML versions of the current set of man-pages.

* Since man-pages-2.69, each man page now includes a COLOPHON
  section at the end of the page which indicates the version of
  man-pages in which this page is released, and also contains a
  pointer to the man-pages web site.

* The list linux-man@vger.kernel.org has been created for
  the purpose of discussing Linux man page bugs, patches,
  and maintenance.  To subscribe, send a message to
  majordomo@vger.kernel.org, with the body:

        subscribe linux-man

Back to the news as usual...

I recently released man-pages-2.71 and man-pages-2.72.

These releases are now available for download at:

    http://www.kernel.org/pub/linux/docs/man-pages
    or ftp://ftp.kernel.org/pub/linux/docs/man-pages

    (Note the s/manpages/man-pages/ in these paths;
    a symlink with the old path will exist for
    a limited time.)

Changes in these releases can be seen at
http://www.kernel.org/doc/man-pages/changelog.html#release_2.71
and
http://www.kernel.org/doc/man-pages/changelog.html#release_2.72

Many of the changes in these releases consist of formatting and consistency
fixes.  A few of the changes that may be of interest to readers of this
list are summarized below.

Cheers,

Michael
(man-pages maintenance is supported by Google, as a Google engineer 20%
project.)


==================== Changes in man-pages-2.71 ====================

Global changes
--------------

err.3
fts.3
getloadavg.3
queue.3
rcmd.3
rexec.3
stdin.3
elf.5
operator.7
    mtk
        Replaced the use of mdoc macros on these pages with man
        macros.  The only pages in man-pages that still use
        mdoc macros are mdoc.7 and mdoc.samples.7.

Typographical or grammatical errors have been corrected in several places.


Changes to individual pages
---------------------------

fcntl.2
    mtk
        Document the F_DUPFD_CLOEXEC operation, which is
        new in kernel 2.6.24.


==================== Changes in man-pages-2.72 ====================

Global changes
--------------

abort.3
    mtk, after a note by Alex Tuninga
        A fairly significant rewrite to clarify operation of abort().


-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html


