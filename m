Return-Path: <linux-kernel-owner+w=401wt.eu-S1762622AbYBUThn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762622AbYBUThn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYBUThX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:37:23 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:46865 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760546AbYBUThV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:37:21 -0500
Date: Thu, 21 Feb 2008 20:37:19 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [announce] Xtables, Xtables-addons 1.5.1 and Writing Xtables Modules
Message-ID: <Pine.LNX.4.64.0802211742431.26109@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,


I have released “Xtables” 1.5.1, which is a package of my ongoing
iptables development¹ that I did lately. Patrick McHardy was not
available last week to merge patches due to higher powers, so I
branched off the iptables subversion trunk into git since quilting on
top of svn was not so fun.

Xtables, that is the goal sought, will merge and unify arptables and 
ebtables² as becomes possible.

What will now become of the iptables and xtables packages? Xtables
clearly is "more recent" than the latest iptables svn, but I would
not want to do Xtables as a continuous parallel fork to iptables³.
Maybe merge⁴ or declare it the new official thing -- who knows.

Additionally, “Xtables-addons” 1.5.1 was released, which is supposed
to supersede patch-o-matic(-ng). As with POM, this package contains
not-so-officially-approved extensions. But different from POM is that
it does not (and will not) contain any "patches" that would require
patching the kernel. Just extensions that can be compiled and then
run instantly.

Furthermore, I would like to make aware of “Writing your own Xtables
module” document, which describes the code needed to get started with
your own xtables modules. It is based upon Nicolas's earlier "Writing
your own iptables module"
 . . . . . . . http://jengelh.hopto.org/documents/Writing_Xtables.pdf

URLs:
tarballs . . . http://dev.computergmbh.de/files/xtables/
gitweb . . . . http://dev.computergmbh.de/gitweb.cgi?p=xtables
 . . . . . . . http://dev.computergmbh.de/gitweb.cgi?p=xtables-addons
gitclone . . . git://dev.computergmbh.de/xtables
 . . . . . . . git://dev.computergmbh.de/xtables-addons

SRPM for reference how to build it in an automatic environment
 . . . . . . . http://ftp.gwdg.de/pub/linux/misc/suser-jengelh/SRPMS/
RPMs (SUSE). . http://ftp.gwdg.de/pub/linux/misc/suser-jengelh/SUSE-10.3/



¹It is supposed to be stable.
²FAQ: On a source base. User-visible commands like ip6tables remain.
³Read: merging forth and back between iptables-svn and xtables-git =
not good.
⁴There were talks about moving the iptables subversion repository to
git, but I could not wait for you guys, sorry ;-)
