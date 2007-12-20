Return-Path: <linux-kernel-owner+w=401wt.eu-S1761877AbXLTMeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761877AbXLTMeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:34:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760409AbXLTMeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:34:21 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:58138 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760201AbXLTMeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:34:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=TitwwgBlVTlGGOAsWNM58NosF4xRKYYKe2CvwXEy2+B5TEl+lxOtbPV1GUJ3IWYThYYsjHvuGTtp0sbt/VCovA7rw/oOu9OQTZrHK9AhHQ+TZ0P4FcqwygSqEH22b0EnHOEdZ9B68ZoWg1/AUjwdHve1OPsGhatv94s5newgKNo=
Message-ID: <476A6147.3020302@gmail.com>
Date: Thu, 20 Dec 2007 13:34:15 +0100
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-2.74 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday

I've released man-pages-2.74.

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/man-pages
    or ftp://ftp.kernel.org/pub/linux/docs/man-pages

Changes in this release can be seen at
http://www.kernel.org/doc/man-pages/changelog.html#release_2.74
A summary of the changes in this release that may be of interest to readers
of this list is provided below.

Cheers,

Michael



Changes to individual pages
---------------------------

mount.2
    mtk, after a note by Sam Morris
        Clarify that MS_NODIRATIME provides a subset of the
        functionality provided by MS_NOATIME.

spu_create.2
    Jeremy Kerr
        We can use context FDs for the dirfd argument to the *at()
        syscalls.

times.2
    mtk, after a note from David Brown and Andrew Morton
        http://marc.info/?l=linux-kernel&m=119447727031225&w=2
        Rework the text describing the return value to be closer
        to the requirements of POSIX.1; move Linux details
        to NOTES and add a warning not to rely on those details.
        Add a warning about the -1 to -4095 bug which results
        in a 41 second window where the glibc wrapper will wrongly
        return -1 indicating an error.

vcs.4
    Samuel Thibault
        Document VT_GETHIFONTMASK (new in 2.6.18) and add to example
        program;
spufs.7
    Jeremy Kerr
        Add a little information about the differences to mbox.
