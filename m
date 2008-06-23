Return-Path: <linux-kernel-owner+w=401wt.eu-S1758239AbYFWNK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbYFWNK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 09:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbYFWNKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 09:10:14 -0400
Received: from gv-out-0910.google.com ([216.239.58.190]:49486 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbYFWNKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 09:10:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=T/0pfcldwAYG+DpkPEBxdrCgd3f73ZVgu8IVrQZJ57PNk/UYhMyxPoMtcnRH4xujTy
         wUnE23QF+9yrHaIawHs/hCIfc6Ba08okftPmw3yCroXdDxltvMkmqVH4q02SukufmCE3
         j40BdhBHiwu8r/PcipLLMneNl/8mqEmbuBjLM=
Message-ID: <48f7fe350806230610y224892e3ob34952b2d8b214a9@mail.gmail.com>
Date: Mon, 23 Jun 2008 09:10:11 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH -mm] .gitignore for mm-sources is missing critical files
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The .gitignore file in the 2.6.26-rc5-mm3 tar ball is incomplete, it
causes many important files to not get added to a git repo. The
patches below fix the issue (sorry they are not all in one diff, it
took me a few try to figure out all the files needed):

diff --git a/f07e4d701ff1fa13f98c21d875f252dc13fa2a42:.gitignore
b/83ad1010c278a37bcd901dde0f7d2b6981f64f6a:.gitignore
index d24ad506e799a5740d19913a333fc9d64261d9c7..9bb1cb6d825d540bc92dfe5c34343438b860b009
100644
--- a/f07e4d701ff1fa13f98c21d875f252dc13fa2a42:.gitignore
+++ b/83ad1010c278a37bcd901dde0f7d2b6981f64f6a:.gitignore
@@ -26,6 +26,7 @@ tags
 TAGS
 vmlinux*
 !vmlinux.lds.S
+!vmlinux.lds.h
 System.map
 Module.markers
 Module.symvers

diff --git a/5ec607502ef909acab4ebe886097523ab4e4e3f5:.gitignore
b/118a64bfe9c4db302820b83a03cc0388f5d620e5:.gitignore
index 9bb1cb6d825d540bc92dfe5c34343438b860b009..71379c18ff4218ba56fd95baf30ac079590ac587
100644
--- a/5ec607502ef909acab4ebe886097523ab4e4e3f5:.gitignore
+++ b/118a64bfe9c4db302820b83a03cc0388f5d620e5:.gitignore
@@ -22,11 +22,15 @@
 #
 # Top-level generic files
 #
+!.mailmap
 tags
 TAGS
 vmlinux*
 !vmlinux.lds.S
 !vmlinux.lds.h
+!vmlinux_32.lds.S
+!vmlinux_64.lds.S
+!vmlinux.scr
 System.map
 Module.markers
 Module.symvers

diff --git a/118a64bfe9c4db302820b83a03cc0388f5d620e5:.gitignore
b/20c660fa39c48b936c3268dbdf179ff84dbbe365:.gitignore
index 71379c18ff4218ba56fd95baf30ac079590ac587..c50ecc6f3c223b51b856c96009f1b9b6539e163d
100644
--- a/118a64bfe9c4db302820b83a03cc0388f5d620e5:.gitignore
+++ b/20c660fa39c48b936c3268dbdf179ff84dbbe365:.gitignore
@@ -35,6 +35,7 @@ System.map
 Module.markers
 Module.symvers
 !.gitignore
+!*.lds

 #
 # Generated include files
