Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYCDFBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYCDFBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 00:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbYCDFA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 00:00:59 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:44390 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYCDFA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 00:00:58 -0500
Date: Tue, 4 Mar 2008 06:00:56 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [announce] Xtables, Xtables-addons 1.5.2
Message-ID: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,


I have released Xtables 1.5.2, which is a package of my ongoing
iptables development. It contains a few patches that make it easier
to build (no kernel source required¹!), and... see shortlog below. I
just rebased it on top of the new converted-from-svn iptables git
tree (which still needs to be officially embraced..); once that
happens it will hopefully merge.  Still, it is stable and can replace
an older iptables package.

Then there is Xtables-addons 1.5.2 out now, which does not have any
new striking changes; just a fix to let it work with older GNU makes
and that it does not depend on the same Xtables version anymore. 
(kernel-source required here, in case you ask.)

I have gotten a number of inquiries regarding Xtables modules, and
yes, I am taking submissions into Xtables-addons.


URLs:
bz2-	http://dev.computergmbh.de/files/xtables/
gitweb-	http://dev.computergmbh.de/gitweb.cgi?p=xtables-dev
gitweb-	http://dev.computergmbh.de/gitweb.cgi?p=xtables-addons
clone-	git://dev.computergmbh.de/xtables-dev
clone-	git://dev.computergmbh.de/xtables-addons

SRPM for reference how to build it in an automatic environment:
	http://ftp.gwdg.de/pub/linux/misc/suser-jengelh/SRPMS/
BRPM:
	http://ftp.gwdg.de/pub/linux/misc/suser-jengelh/SUSE-10.3/


¹Unless you cross-compile.

Xtables:
Jan Engelhardt (24):
      Update .gitignore
      Fix compilation of iptables-static build
      Correct the family member value of libxt_mark rev.1
      Makefile: add a "tarball" target
      Drop -W from CFLAGS and some tiny code cleanups
      Fix -Wshadow warnings and clean up xt_sctp.h.
      Fix all remaining warnings (missing declarations, missing prototypes)
      Add support for xt_hashlimit match revision 1
      Update the libxt_owner manpage with the UID/GID-range feature
      Combine IP{,6}T_LIB_DIR into XTABLES_LIBDIR
      Move libipt_recent to libxt_recent
      Add IPv6 support to libxt_recent
      Add all necessary header files - compilation fix for various cases
      Update package name (Xtables) and documentation
      configure: split --enable-libipq from --enable-devel
      Install libiptc header files because xtables.h depends on it
      Remove support for compilation of conditional extensions
      Combine ipt and ip6t manpages
      Implement AF_UNSPEC as a wildcard for extensions
      Change IPTABLES_VERSION to XTABLES_VERSION
      Update spelling and grammar in manpages
      Fix broken markup in manpages
      Clarify prerequisites of Xtables and update option notes
      Xtables 1.5.2
