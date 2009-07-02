Return-Path: <linux-kernel-owner+w=401wt.eu-S1753353AbZGBFb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353AbZGBFb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbZGBFbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:31:47 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:58731 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbZGBFbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:31:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=kFQDLbiNi4sTxQ11F41guXVBW2jHhxGlhKHzaaMdU/iL4HmUn3afmj9F4Ubc7pk8X9
         Fp7+YU17UtEN5zGxi3l5+QTxOZViZkSEP3IyJoz/wCyrOZI63Q/Uq/Hqzf3wG18HZAWZ
         gXJfXfIfeIU7SmgCD4tdu/HqumjL/Pp4w/WVw=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: selinux@tycho.nsa.gov
Subject: SELinux-non-trivial-fixes.
Date: Wed,  1 Jul 2009 22:32:39 -0700
Message-Id: <1246512767-2999-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I decided to sit and manually write out all of the SELinux
area(or at least some of it). So along the way
whenever I saw what might need a bit of cleaning up
I wrote it down, and then once finished
created a patch to submit for you guy's to decide.
 
So here you go(still need to go into the other directories,
and will later on) but for now hope you like what you see,
and if you see something that might need changing send me a post. 



 security/selinux/avc.c       |   21 ++--
 security/selinux/hooks.c     |  265 +++++++++++++++++++++---------------------
 security/selinux/netif.c     |   12 +-
 security/selinux/netlabel.c  |   10 +-
 security/selinux/netnode.c   |   20 ++--
 security/selinux/netport.c   |   12 +-
 security/selinux/selinuxfs.c |   61 +++++-----
 security/selinux/xfrm.c      |   26 ++--
 8 files changed, 213 insertions(+), 214 deletions(-)



