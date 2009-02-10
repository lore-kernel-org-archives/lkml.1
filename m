Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbZBKBgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbZBKBgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 20:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbZBKBgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 20:36:12 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:8009 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbZBKBgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 20:36:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=wvFIyooNqN9J8TzrFZT3NRVzfpLn3Qy4dvw16kNtEQRs89kV318LzivsmI205WBjDz
         8BYd5SI0X2PskDew8w8UHQoFWRvYaha9kyUPNAsgu5KBk/gDAzGiLLq05d1yqxaCTiCV
         cSRqc/Tj6odzxJQSQ5R7iVeqplG9hxpXIT3x8=
Message-ID: <4990D9E0.30904@gmail.com>
Date: Tue, 10 Feb 2009 14:35:28 +1300
From: Michael Kerrisk <mtk.manpages@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-3.18 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've happy to announce

    man-pages-3.18.tar.gz - man pages for Linux,

my hundredth release since I took over maintainership in 2004.

This release is now available for download at:

  http://www.kernel.org/pub/linux/docs/man-pages
  or ftp://ftp.kernel.org/pub/linux/docs/man-pages

man-pages nowadays also has a public git repository at

  git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git

The online changelog is available at
http://www.kernel.org/doc/man-pages/changelog.html
(blogged at
http://linux-man-pages.blogspot.com/2009/02/man-pages-318-is-released.html)
and the current version of the pages is browsable at
http://www.kernel.org/doc/man-pages/
An abridged list of changes that may be of interest to readers of this
list is given below.

Cheers,

Michael


==================== Changes in man-pages-3.18 ====================

New and rewritten pages
-----------------------

armscii-8.7
    Lefteris Dimitroulakis
        New page documenting ArmSCII-8 character set

iso_8859-11.7
    Lefteris Dimitroulakis
        New page documenting ISO 8859-11 character set

iso_8859-4.7
    Lefteris Dimitroulakis
        New page documenting ISO 8859-4 character set

iso_8859-6.7
    Lefteris Dimitroulakis
        New page describing ISO 8859-6 character set

pthread_kill.3
    Michael Kerrisk
        New page documenting pthread_kill(3)

pthread_kill_other_threads_np.3
    Michael Kerrisk
        New page documenting pthread_kill_other_threads_np(3)

pthread_sigmask.3
    Michael Kerrisk
        New page documenting pthread_sigmask(3)


Newly documented interfaces in existing pages
---------------------------------------------

clock_getres.3
    Michael Kerrisk
        Document CLOCK_MONOTONIC_RAW, new in 2.6.28


Changes to individual pages
---------------------------

capget.2
    Andi Kleen
        Add some details and relocate a paragraph
            While writing a little program using capset
            I found the capset manpage quite light on crucial
            details and I had to resort to RTFS.

            This patch improves the points I found unclear
            and also moves one misplaced paragraph around.

select_tut.2
    Michael Kerrisk
        Clean up error checking in example program (no semantic changes)
    Michael Kerrisk
        Many parts tidied and rewritten
            Remove some redundant text, clarify various pieces,
            tidy example code, etc.
    Michael Kerrisk
        Bug fixes + rewrites in example program
            Sebastien pointed out that the first example program
            wrongly thinks it can count signals.
            Also, some further rewrites by mtk.

epoll.7
    Michael Kerrisk
        remove documentation of /proc/sys/fs/epoll/max_user_instances
            This /proc interface appeared in 2.6.28. but will be
            removed in 2.6.29.

            Also, document change in default value of
            /proc/sys/fs/epoll/max_user_watches (was 1/32 of lowmem,
            now 1/25 of lowmem).

standards.7
    Michael Kerrisk
        Update to note that latest POSIX/SUS was ratified in 2008

