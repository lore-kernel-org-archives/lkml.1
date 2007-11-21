Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433AbXKURLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433AbXKURLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 12:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbXKURLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 12:11:01 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:32175 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbXKURK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 12:10:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=Iy8obZjaTYAOKKw9maWqBMMBBiU/cWozFlvf3filFKUn14bJEptPX7313ixe2i4sXFz0kiKl1Og2K3FbcB9uDmLrQ4cphY3k5y1fPqMVKrWxSAWPn4NkJawWL1TTfNyY0IaYpy6kGB0zeNu3twHK0yyLeaI8py+KNj2v/KJ89zc=
Message-ID: <47446754.8080804@gmail.com>
Date: Wed, 21 Nov 2007 18:13:56 +0100
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: man-pages-2.68 is released
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

Repeating some old news:

1) As from now, my address as man-pages maintainer has changed
   to mtk.manpages@gmail.com.  (Mail to the old address will
   continue to work for a while, but eventually I will close
   that account.)

2) The list linux-man@vger.kernel.org has been created for
   the purpose of discussing Linux man page bugs, patches,
   and maintenance.  To subscribe, send a message to
   majordomo@vger.kernel.org, with the body:

        subscribe linux-man

Back to the news as usual...

I recently released man-pages-2.68.

This release is now available for download at:

    http://www.kernel.org/pub/linux/docs/man-pages
    or ftp://ftp.kernel.org/pub/linux/docs/man-pages

    (Note the s/manpages/man-pages/ in these paths;
    a symlink with the old path will exist for
    a limited time.)

Changes in the release that may be of interest to readers of this list are
summarized below.

Cheers,

Michael
(man-pages maintenance is supported by Google, as a Google engineer 20%
project.)


==================== Changes in man-pages-2.68 ====================

New pages
---------

_syscall.2
    mtk
        Created as a new page, by taking the content specific to
        the _syscall() macros from intro(2).


Changes to individual pages
---------------------------

intro.2
    mtk
        Pretty much a complete rewrite, covering some additional topics.
        Moved _syscallN() material to new _syscall(2) page.

prctl.2
    mtk
        Linux 2.6.22 added support on Alpha for PR_SET_UNALIGN.

intro.3
    mtk
        Pretty much a complete rewrite, covering some additional topics.

elf.5
    Mike Frysinger
        Document:
        - new p_flag: PT_GNU_STACK
        - new sections: .gnu.version .gnu.version_d .gnu.version_r
          .note.GNU-stack
        - new structures: ElfN_Verdef ElfN_Verdaux ElfN_Verneed
          ElfN_Vernaux

proc.5
    Ivana Varekova / mtk
        Add text noting that since kernel 2.6.16, /proc/slabinfo is
        only available if CONFIG_SLAB is enabled.
    Maxime Vaudequin
        Update description of /proc/pci.
    mtk
        The display type of the /proc/PID/stat fields changed
        %lu to %u in Linux 2.6.22:
            flags
            rt_priority
            policy

slabinfo.5
    Ivana Varekova / mtk
        Add text noting that since kernel 2.6.16, /proc/slabinfo is
        only available if CONFIG_SLAB is enabled.

ipv6.7
    Andrew McDonald
        Fix description of IPV6_ROUTER_ALERT option.

