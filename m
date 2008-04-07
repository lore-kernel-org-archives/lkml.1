Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYDGHqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYDGHqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 03:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbYDGHqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 03:46:01 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:45740 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbYDGHqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 03:46:01 -0400
Message-ID: <000701c89883$6a12bdd0$3d02a8c0@D35PN52J>
From: "Charlie Gordon" <gnu@chqrlie.org>
To: <linux-kernel@vger.kernel.org>
Subject: PROBLEM: documentation error in man page for ptsname(3)
Date: Mon, 7 Apr 2008 09:45:56 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prototype for ptsname_r is incorrect.  It reads:

char *ptsname_r(int fd, char *buf, size_t buflen);

The actual prototype for this function in glibc stdlib.h is

extern int ptsname_r (int __fd, char *__buf, size_t __buflen);

This is very confusing as the test for an error is exactly the opposite ;-)

The manual page is dated 2004-12-17, but seems current as part of release 
2.79.  The bug is present in the online version at 
http://www.kernel.org/doc/man-pages/online/pages/man3/ptsname.3.html .

THX

-- 
Charles Gordon (chqrlie)

