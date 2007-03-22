Return-Path: <linux-kernel-owner+w=401wt.eu-S965539AbXCVAlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965539AbXCVAlx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 20:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934099AbXCVAlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 20:41:53 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:38374 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934083AbXCVAlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 20:41:52 -0400
Message-ID: <04d701c76c1b$26d63dc0$eeeea8c0@aldipc>
From: "roland" <devzero@web.de>
To: <linux-kernel@vger.kernel.org>
Cc: <bunk@stusta.de>
Subject: warning: #warning You have not edited mcdx.h
Date: Thu, 22 Mar 2007 01:43:19 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2869
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2869
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

while looking at some more warnings i got with allyesconfig i came across 
this really weird one:

In file included from drivers/cdrom/mcdx.c:78:
drivers/cdrom/mcdx.h:180:2: warning: #warning You have not edited mcdx.h
drivers/cdrom/mcdx.h:181:2: warning: #warning Perhaps irq and i/o settings 
are wrong.

looking into the code :

#ifndef I_WAS_HERE
#ifndef MODULE
#warning You have not edited mcdx.h
#warning Perhaps irq and i/o settings are wrong.
#endif
#endif

and before:
/* *** make the following line uncommented, if you're sure,
 * *** all configuration is done */
/* #define I_WAS_HERE */

huh?

is this file meant to be edited before compile ?


searched the list and came across some patch from adrian bunk:

[Patch] (new version) configure mcdx without editing mcdx.h

at http://marc.info/?l=linux-kernel&m=94772887906874&w=2
and http://marc.info/?l=linux-kernel&m=94724271712637&w=2
and http://marc.info/?l=linux-kernel&m=94699770112439&w=2

has this never been merged ?

regards
roland



